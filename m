Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30B56E5811
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Apr 2023 06:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjDREZy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Apr 2023 00:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjDREZx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Apr 2023 00:25:53 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE1F9D
        for <ceph-devel@vger.kernel.org>; Mon, 17 Apr 2023 21:25:48 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id ay3-20020a05600c1e0300b003f17289710aso2781622wmb.5
        for <ceph-devel@vger.kernel.org>; Mon, 17 Apr 2023 21:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681791947; x=1684383947;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WW5WrNueTiO3CW+MM6qDR8C8PYaeglvNUKKUr72PzWI=;
        b=WNWsheRGFXizRXYPuBut24JfvzwGDLyViqZw1gpo0ah2mmBzP978cjaWCj4wpzKN8I
         6dhpJfv3NDfv2AEEDWp1iAdneQtSIEHgFVx6w2lluEiv2pT4RjE9/8xHIJmq+OWke87X
         eJna+K4XnSs0a/p5Pj4ilqRW7gIr6/BqlpkrUNpEGOm8HEQyWht4PVqMwsH+bAqsCTim
         dNELlOrubEhUUQa/hyqmjtsHsR8kGhwxgmCrwhAVHZ1b14EZ4z9vLmayGfBNgNtgc0Mx
         Cs/wOev/ubukLXLucQcwtRLR6kOplIFtXZHrRJFkK6UjZgQY0QJRH4k0fGnK4u3rf4mI
         G3Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681791947; x=1684383947;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WW5WrNueTiO3CW+MM6qDR8C8PYaeglvNUKKUr72PzWI=;
        b=JIgXbcXDgh9Lsj4DnTONm/B29EW7GLOfZ4WAyT0PvQW+UWjw4R3/UjiDAnKpyWURls
         LY3n50N4NueQR19EASiCZOhhQT5kB53beVTyVOgmq9AW0M+30jGXU9FtPoZ4hkDFEcwS
         HxFvuS+sdnYzdqSo4aLkKtWZCEsqUnJ56vxtEEAOS8q0haPEibb6Kx8KkaP7jDM5tBeJ
         NwAtFw8gMg6I/DBYae5GzNWdwUM5J1q6pieohcFq+76Yx3WJNOk12s2xcdf8nzIaZPVV
         Lf7XW7ubxw7YhjonurXDh4fTc8IYoTKoQCfe142EuFl5apAm4PhyTuA2Vkcm2x3B8PYh
         N4cA==
X-Gm-Message-State: AAQBX9cLOdt/XCIngQRJ3XEOs1i6lsN7+ZW5myU1xUaU69tyIzqPORly
        8rLjkdf7fngdEaQkzhvYMbw=
X-Google-Smtp-Source: AKy350aOmgzs3ZLCHUrSSw7oajzxhMJpYK3jJ683N49aXr0gyL/ER/h/x1JkCKeIFg7SpTmmV1wzuQ==
X-Received: by 2002:a7b:c848:0:b0:3f1:7368:ccc6 with SMTP id c8-20020a7bc848000000b003f17368ccc6mr3920483wml.25.1681791946666;
        Mon, 17 Apr 2023 21:25:46 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id 26-20020a05600c021a00b003f17848673fsm1210492wmi.27.2023.04.17.21.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 21:25:46 -0700 (PDT)
Date:   Tue, 18 Apr 2023 07:25:41 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     oe-kbuild@lists.linux.dev, Xiubo Li <xiubli@redhat.com>
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev,
        ceph-devel@vger.kernel.org
Subject: [ceph-client:testing 77/77] fs/ceph/mds_client.c:1957
 wake_up_session_cb() error: potentially dereferencing uninitialized 'cap'.
Message-ID: <1a89b8e8-f52c-4005-a4ad-85935679f275@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   3fef7c3fd10c5f078e0f6ec8c683f2d1e14eb05d
commit: 3fef7c3fd10c5f078e0f6ec8c683f2d1e14eb05d [77/77] ceph: fix potential use-after-free bug when trimming caps
config: i386-randconfig-m021-20230417 (https://download.01.org/0day-ci/archive/20230418/202304180424.Dok2kyeU-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>
| Link: https://lore.kernel.org/r/202304180424.Dok2kyeU-lkp@intel.com/

New smatch warnings:
fs/ceph/mds_client.c:1957 wake_up_session_cb() error: potentially dereferencing uninitialized 'cap'.

Old smatch warnings:
fs/ceph/mds_client.c:219 parse_reply_info_in() warn: missing unwind goto?

vim +/cap +1957 fs/ceph/mds_client.c

3fef7c3fd10c5f Xiubo Li    2023-04-14  1945  static int wake_up_session_cb(struct inode *inode, struct rb_node *ci_node, void *arg)
2f2dc053404feb Sage Weil   2009-10-06  1946  {
0dc2570fab222a Sage Weil   2009-11-20  1947  	struct ceph_inode_info *ci = ceph_inode(inode);
d2f8bb27c87945 Yan, Zheng  2018-12-10  1948  	unsigned long ev = (unsigned long)arg;
3fef7c3fd10c5f Xiubo Li    2023-04-14  1949  	struct ceph_cap *cap;
0dc2570fab222a Sage Weil   2009-11-20  1950  
d2f8bb27c87945 Yan, Zheng  2018-12-10  1951  	if (ev == RECONNECT) {
be655596b3de58 Sage Weil   2011-11-30  1952  		spin_lock(&ci->i_ceph_lock);
0dc2570fab222a Sage Weil   2009-11-20  1953  		ci->i_wanted_max_size = 0;
0dc2570fab222a Sage Weil   2009-11-20  1954  		ci->i_requested_max_size = 0;
be655596b3de58 Sage Weil   2011-11-30  1955  		spin_unlock(&ci->i_ceph_lock);
d2f8bb27c87945 Yan, Zheng  2018-12-10  1956  	} else if (ev == RENEWCAPS) {
52d60f8e18b855 Jeff Layton 2021-06-04 @1957  		if (cap->cap_gen < atomic_read(&cap->session->s_cap_gen)) {
                                                            ^^^^^^^^^^^^               ^^^^^^^^^^^^^

d2f8bb27c87945 Yan, Zheng  2018-12-10  1958  			/* mds did not re-issue stale cap */
d2f8bb27c87945 Yan, Zheng  2018-12-10  1959  			spin_lock(&ci->i_ceph_lock);
3fef7c3fd10c5f Xiubo Li    2023-04-14  1960  			cap = rb_entry(ci_node, struct ceph_cap, ci_node);
                                                                ^^^^^^^^^^^^^^
Initialized too late.

3fef7c3fd10c5f Xiubo Li    2023-04-14  1961  			if (cap)
d2f8bb27c87945 Yan, Zheng  2018-12-10  1962  				cap->issued = cap->implemented = CEPH_CAP_PIN;
d2f8bb27c87945 Yan, Zheng  2018-12-10  1963  			spin_unlock(&ci->i_ceph_lock);
d2f8bb27c87945 Yan, Zheng  2018-12-10  1964  		}
d2f8bb27c87945 Yan, Zheng  2018-12-10  1965  	} else if (ev == FORCE_RO) {
0dc2570fab222a Sage Weil   2009-11-20  1966  	}
e536030934aebf Yan, Zheng  2016-05-19  1967  	wake_up_all(&ci->i_cap_wq);
2f2dc053404feb Sage Weil   2009-10-06  1968  	return 0;
2f2dc053404feb Sage Weil   2009-10-06  1969  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

