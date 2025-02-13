Return-Path: <ceph-devel+bounces-2663-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DFCEA34DB7
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2025 19:29:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2F4D188C439
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2025 18:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE8F28A2DC;
	Thu, 13 Feb 2025 18:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BY+GVBha"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86F4241690
	for <ceph-devel@vger.kernel.org>; Thu, 13 Feb 2025 18:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739471355; cv=none; b=APK5BDzf8CK5ZHeIX8cBXMUker8TXxJltxb8S/70zEHyR2W4GHLp6LgX13kaaD0XwM0fOdPouJV/RXLktU7TPLDS63ruTdq75g5t7r3r+Tiw0GIO0J5o3ERD0tXxSksSDtFL7sQsEui4ocOyYtvlKqaYCpV8KCqLUnn+TLeeF8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739471355; c=relaxed/simple;
	bh=Vls1h9b6LaiRYq0jkikt3QM36hYAo1T0Ul1t553zcpM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HxVFESsDWtYEFqnMN500XY0e/dOqZYsm6Lh0pTI6KuTt2hYvx03Y574fLATcp3bdhqk4IrEjo0OpkVv+5YUlnagbwz6idmvWM1VGGQskk7IX7/qG8JIq4e6NFgKSsSXVSi+OMNoX24H36QIF0SR6lJVn4CDw9ZXbgJJdXNQ5t1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BY+GVBha; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739471354; x=1771007354;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Vls1h9b6LaiRYq0jkikt3QM36hYAo1T0Ul1t553zcpM=;
  b=BY+GVBhaKtqby24SFhRgIZoGJKDqequ/CWGGzYdDQbk0csaiC1SWro99
   nY7CP3rCUcWH7cO0FSRrwUwk37mc813Scnx6QMa/Zou1MAUDaw6pG5L3X
   IAvzDhLlCeikMXAV1qjsqgoO8RvXRC3RNKjwAfM+0+sQ60rrygBfXcsYv
   2Lxy7NKodbQ4808wuIOUJDLwTi9dpzfJI1vHnrifrvMYYOJu/BUzE3Xj3
   yA+tVhvcZluFjZpyMYfja6VMsDqImugyQ9FfT65MuQhOdIinkDJhNxKPQ
   4PYR0mzakwdHyf3PZXsKfyx/QzL74g/YZtFQgyfBrk22tLbdoLNN7NqO2
   w==;
X-CSE-ConnectionGUID: jFeXQBnLTI2eXAe4qbFAOw==
X-CSE-MsgGUID: LxnayCSiQi2ak1WhjZYrbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11344"; a="43961706"
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="43961706"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2025 10:29:13 -0800
X-CSE-ConnectionGUID: 3UmGvbXNSoiaNb4XFiqiNQ==
X-CSE-MsgGUID: k1bCbTfSRC+akK8WgdwsoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,282,1732608000"; 
   d="scan'208";a="112970290"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 13 Feb 2025 10:29:12 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tidxV-0018ZX-2q;
	Thu, 13 Feb 2025 18:29:09 +0000
Date: Fri, 14 Feb 2025 02:29:04 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Markuze <amarkuze@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	ceph-devel@vger.kernel.org
Subject: [ceph-client:tls_logger 13/13] net/ceph/messenger_v2.c:2791:12:
 warning: stack frame size (9848) exceeds limit (8192) in 'process_control'
Message-ID: <202502140205.1AGkREJM-lkp@intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/ceph/ceph-client.git tls_logger
head:   cd1e899feeb6a7da55cbb74b9245c8bbb77f82ba
commit: cd1e899feeb6a7da55cbb74b9245c8bbb77f82ba [13/13] cephsun: using a dynamic buffer allocation
config: x86_64-randconfig-005-20250213 (https://download.01.org/0day-ci/archive/20250214/202502140205.1AGkREJM-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250214/202502140205.1AGkREJM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502140205.1AGkREJM-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> net/ceph/messenger_v2.c:2791:12: warning: stack frame size (9848) exceeds limit (8192) in 'process_control' [-Wframe-larger-than]
    2791 | static int process_control(struct ceph_connection *con, void *p, void *end)
         |            ^
   1 warning generated.
--
>> net/ceph/messenger_v1.c:1326:5: warning: stack frame size (13688) exceeds limit (8192) in 'ceph_con_v1_try_read' [-Wframe-larger-than]
    1326 | int ceph_con_v1_try_read(struct ceph_connection *con)
         |     ^
   1 warning generated.


vim +/process_control +2791 net/ceph/messenger_v2.c

cd1a677cad99402 Ilya Dryomov 2020-11-19  2790  
cd1a677cad99402 Ilya Dryomov 2020-11-19 @2791  static int process_control(struct ceph_connection *con, void *p, void *end)
cd1a677cad99402 Ilya Dryomov 2020-11-19  2792  {
cd1a677cad99402 Ilya Dryomov 2020-11-19  2793  	int tag = con->v2.in_desc.fd_tag;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2794  	int ret;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2795  
cd1a677cad99402 Ilya Dryomov 2020-11-19  2796  	dout("%s con %p tag %d len %d\n", __func__, con, tag, (int)(end - p));
cd1a677cad99402 Ilya Dryomov 2020-11-19  2797  
cd1a677cad99402 Ilya Dryomov 2020-11-19  2798  	switch (tag) {
cd1a677cad99402 Ilya Dryomov 2020-11-19  2799  	case FRAME_TAG_HELLO:
cd1a677cad99402 Ilya Dryomov 2020-11-19  2800  		ret = process_hello(con, p, end);
cd1a677cad99402 Ilya Dryomov 2020-11-19  2801  		break;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2802  	case FRAME_TAG_AUTH_BAD_METHOD:
cd1a677cad99402 Ilya Dryomov 2020-11-19  2803  		ret = process_auth_bad_method(con, p, end);
cd1a677cad99402 Ilya Dryomov 2020-11-19  2804  		break;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2805  	case FRAME_TAG_AUTH_REPLY_MORE:
cd1a677cad99402 Ilya Dryomov 2020-11-19  2806  		ret = process_auth_reply_more(con, p, end);
cd1a677cad99402 Ilya Dryomov 2020-11-19  2807  		break;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2808  	case FRAME_TAG_AUTH_DONE:
cd1a677cad99402 Ilya Dryomov 2020-11-19  2809  		ret = process_auth_done(con, p, end);
cd1a677cad99402 Ilya Dryomov 2020-11-19  2810  		break;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2811  	case FRAME_TAG_AUTH_SIGNATURE:
cd1a677cad99402 Ilya Dryomov 2020-11-19  2812  		ret = process_auth_signature(con, p, end);
cd1a677cad99402 Ilya Dryomov 2020-11-19  2813  		break;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2814  	case FRAME_TAG_SERVER_IDENT:
cd1a677cad99402 Ilya Dryomov 2020-11-19  2815  		ret = process_server_ident(con, p, end);
cd1a677cad99402 Ilya Dryomov 2020-11-19  2816  		break;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2817  	case FRAME_TAG_IDENT_MISSING_FEATURES:
cd1a677cad99402 Ilya Dryomov 2020-11-19  2818  		ret = process_ident_missing_features(con, p, end);
cd1a677cad99402 Ilya Dryomov 2020-11-19  2819  		break;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2820  	case FRAME_TAG_SESSION_RECONNECT_OK:
cd1a677cad99402 Ilya Dryomov 2020-11-19  2821  		ret = process_session_reconnect_ok(con, p, end);
cd1a677cad99402 Ilya Dryomov 2020-11-19  2822  		break;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2823  	case FRAME_TAG_SESSION_RETRY:
cd1a677cad99402 Ilya Dryomov 2020-11-19  2824  		ret = process_session_retry(con, p, end);
cd1a677cad99402 Ilya Dryomov 2020-11-19  2825  		break;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2826  	case FRAME_TAG_SESSION_RETRY_GLOBAL:
cd1a677cad99402 Ilya Dryomov 2020-11-19  2827  		ret = process_session_retry_global(con, p, end);
cd1a677cad99402 Ilya Dryomov 2020-11-19  2828  		break;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2829  	case FRAME_TAG_SESSION_RESET:
cd1a677cad99402 Ilya Dryomov 2020-11-19  2830  		ret = process_session_reset(con, p, end);
cd1a677cad99402 Ilya Dryomov 2020-11-19  2831  		break;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2832  	case FRAME_TAG_KEEPALIVE2_ACK:
cd1a677cad99402 Ilya Dryomov 2020-11-19  2833  		ret = process_keepalive2_ack(con, p, end);
cd1a677cad99402 Ilya Dryomov 2020-11-19  2834  		break;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2835  	case FRAME_TAG_ACK:
cd1a677cad99402 Ilya Dryomov 2020-11-19  2836  		ret = process_ack(con, p, end);
cd1a677cad99402 Ilya Dryomov 2020-11-19  2837  		break;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2838  	default:
cd1a677cad99402 Ilya Dryomov 2020-11-19  2839  		pr_err("bad tag %d\n", tag);
cd1a677cad99402 Ilya Dryomov 2020-11-19  2840  		con->error_msg = "protocol error, bad tag";
cd1a677cad99402 Ilya Dryomov 2020-11-19  2841  		return -EINVAL;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2842  	}
cd1a677cad99402 Ilya Dryomov 2020-11-19  2843  	if (ret) {
cd1a677cad99402 Ilya Dryomov 2020-11-19  2844  		dout("%s con %p error %d\n", __func__, con, ret);
cd1a677cad99402 Ilya Dryomov 2020-11-19  2845  		return ret;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2846  	}
cd1a677cad99402 Ilya Dryomov 2020-11-19  2847  
cd1a677cad99402 Ilya Dryomov 2020-11-19  2848  	prepare_read_preamble(con);
cd1a677cad99402 Ilya Dryomov 2020-11-19  2849  	return 0;
cd1a677cad99402 Ilya Dryomov 2020-11-19  2850  }
cd1a677cad99402 Ilya Dryomov 2020-11-19  2851  

:::::: The code at line 2791 was first introduced by commit
:::::: cd1a677cad994021b19665ed476aea63f5d54f31 libceph, ceph: implement msgr2.1 protocol (crc and secure modes)

:::::: TO: Ilya Dryomov <idryomov@gmail.com>
:::::: CC: Ilya Dryomov <idryomov@gmail.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

