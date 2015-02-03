package io.dcloud.feature.barcode;

import io.dcloud.DHInterface.AbsMgr;
import io.dcloud.DHInterface.IFeature;
import io.dcloud.DHInterface.IWebview;

public class BarcodeFeatureImpl implements IFeature {

	BarcodeProxy mProxy = null;
	@Override
	public String execute(IWebview pWebViewImpl, String pActionName,
			String[] pJsArgs) {
		mProxy.execute(pWebViewImpl, pActionName, pJsArgs);
		return null;
	}

	@Override
	public void init(AbsMgr pFeatureMgr, String pFeatureName) {
		mProxy = new BarcodeProxy();
	}

	@Override
	public void dispose(String pAppid) {
		mProxy.onDestroy();
	}
}
