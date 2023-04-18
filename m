Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D542F6E5986
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Apr 2023 08:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjDRGj2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Apr 2023 02:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjDRGj1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Apr 2023 02:39:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD5F40C6
        for <ceph-devel@vger.kernel.org>; Mon, 17 Apr 2023 23:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681799917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dUq4DBoYKw2CrRQTHlHo7wdWkO9/bwTxxLkECJNUP2Y=;
        b=EpwMrCZcAny+kxlvGAWtHZA0R2sM6uY8ryaoBzpEbN8BJEVs6j3ijbAbTvQVTLT7lwpPWk
        VaX56bI0aXkOsDHqeIeMM6lxDnNJUItpwdHdthMHpJfnP96rx04R41mf+apCQNe8ZzGTlW
        wpvb8xMu7adaCPPMx4fK5x+pQL54jhM=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-E3JtSObaP_eFfu7f9zVAjg-1; Tue, 18 Apr 2023 02:38:36 -0400
X-MC-Unique: E3JtSObaP_eFfu7f9zVAjg-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-63b63bd77a8so1656431b3a.2
        for <ceph-devel@vger.kernel.org>; Mon, 17 Apr 2023 23:38:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681799915; x=1684391915;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dUq4DBoYKw2CrRQTHlHo7wdWkO9/bwTxxLkECJNUP2Y=;
        b=g247VxEEvyPJKuOGGfS0BMzE8RKa3ANI0WuKW+K7U9E4UDgcSpWnpujsqUPv7FRSBE
         D+NPaR5gI2tEQM632N5x2qWQQp0GxFRen3yXJMLrPBZJznuze/MadT3CVqTt9WwooWkr
         FkP2gyT4MZD8e0kHD/S9r4PT5exORlxV+nnpFO4Mv/gwhpvzfLoTdnccOUrNzdB0TYnR
         WhdWlKL2TVSuE56qjZu3Iu5AiYL0/Kw1FbN+Ib5e9VsmlxBtzcMwhgD81XgNWWHbaSCX
         xM+ik0br2vRY7Iy8kfYG4lKb8sEpPwE91wICm2lcQXL12l7vTOzcpcecVVGIgaQpdxJ+
         lm5A==
X-Gm-Message-State: AAQBX9ctpAJ2owMeJufvj3zIjtTJcVmIWlSyJXowYrmSYarM+w5NAwl/
        v+kg6gHHygnwoiGo1RvnK3K8dlUQrSjyHj+TpCPSflYLh5fth0MbCecL33qnFXWoSb2YwOIjFWC
        q5wn4RMchhXSThyt7QctBx9eOPhJeqrdFq4U=
X-Received: by 2002:a05:6a00:179a:b0:63b:8eeb:77b8 with SMTP id s26-20020a056a00179a00b0063b8eeb77b8mr8656927pfg.13.1681799914930;
        Mon, 17 Apr 2023 23:38:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZNbXSNUUYsBhTQbe9GMU0xrqcf8HbI9WS2+Jfi5zGuFwjotUORgVkX4FbdGyl/MFe3tdOccg==
X-Received: by 2002:a05:6a00:179a:b0:63b:8eeb:77b8 with SMTP id s26-20020a056a00179a00b0063b8eeb77b8mr8656912pfg.13.1681799914607;
        Mon, 17 Apr 2023 23:38:34 -0700 (PDT)
Received: from [10.72.12.132] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y6-20020aa78546000000b0063d238b1e4bsm2576855pfn.160.2023.04.17.23.38.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 23:38:34 -0700 (PDT)
Message-ID: <447bea60-537d-5872-bfad-37caf97ccc43@redhat.com>
Date:   Tue, 18 Apr 2023 14:38:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [ceph-client:testing 77/77] fs/ceph/mds_client.c:1957
 wake_up_session_cb() error: potentially dereferencing uninitialized 'cap'.
Content-Language: en-US
To:     Dan Carpenter <error27@gmail.com>, oe-kbuild@lists.linux.dev
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev,
        ceph-devel@vger.kernel.org
References: <1a89b8e8-f52c-4005-a4ad-85935679f275@kili.mountain>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <1a89b8e8-f52c-4005-a4ad-85935679f275@kili.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Dan,

Thanks for reporting.

This has been fixed already.

- Xiubo

On 4/18/23 12:25, Dan Carpenter wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   3fef7c3fd10c5f078e0f6ec8c683f2d1e14eb05d
> commit: 3fef7c3fd10c5f078e0f6ec8c683f2d1e14eb05d [77/77] ceph: fix potential use-after-free bug when trimming caps
> config: i386-randconfig-m021-20230417 (https://download.01.org/0day-ci/archive/20230418/202304180424.Dok2kyeU-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <error27@gmail.com>
> | Link: https://lore.kernel.org/r/202304180424.Dok2kyeU-lkp@intel.com/
>
> New smatch warnings:
> fs/ceph/mds_client.c:1957 wake_up_session_cb() error: potentially dereferencing uninitialized 'cap'.
>
> Old smatch warnings:
> fs/ceph/mds_client.c:219 parse_reply_info_in() warn: missing unwind goto?
>
> vim +/cap +1957 fs/ceph/mds_client.c
>
> 3fef7c3fd10c5f Xiubo Li    2023-04-14  1945  static int wake_up_session_cb(struct inode *inode, struct rb_node *ci_node, void *arg)
> 2f2dc053404feb Sage Weil   2009-10-06  1946  {
> 0dc2570fab222a Sage Weil   2009-11-20  1947  	struct ceph_inode_info *ci = ceph_inode(inode);
> d2f8bb27c87945 Yan, Zheng  2018-12-10  1948  	unsigned long ev = (unsigned long)arg;
> 3fef7c3fd10c5f Xiubo Li    2023-04-14  1949  	struct ceph_cap *cap;
> 0dc2570fab222a Sage Weil   2009-11-20  1950
> d2f8bb27c87945 Yan, Zheng  2018-12-10  1951  	if (ev == RECONNECT) {
> be655596b3de58 Sage Weil   2011-11-30  1952  		spin_lock(&ci->i_ceph_lock);
> 0dc2570fab222a Sage Weil   2009-11-20  1953  		ci->i_wanted_max_size = 0;
> 0dc2570fab222a Sage Weil   2009-11-20  1954  		ci->i_requested_max_size = 0;
> be655596b3de58 Sage Weil   2011-11-30  1955  		spin_unlock(&ci->i_ceph_lock);
> d2f8bb27c87945 Yan, Zheng  2018-12-10  1956  	} else if (ev == RENEWCAPS) {
> 52d60f8e18b855 Jeff Layton 2021-06-04 @1957  		if (cap->cap_gen < atomic_read(&cap->session->s_cap_gen)) {
>                                                              ^^^^^^^^^^^^               ^^^^^^^^^^^^^
>
> d2f8bb27c87945 Yan, Zheng  2018-12-10  1958  			/* mds did not re-issue stale cap */
> d2f8bb27c87945 Yan, Zheng  2018-12-10  1959  			spin_lock(&ci->i_ceph_lock);
> 3fef7c3fd10c5f Xiubo Li    2023-04-14  1960  			cap = rb_entry(ci_node, struct ceph_cap, ci_node);
>                                                                  ^^^^^^^^^^^^^^
> Initialized too late.
>
> 3fef7c3fd10c5f Xiubo Li    2023-04-14  1961  			if (cap)
> d2f8bb27c87945 Yan, Zheng  2018-12-10  1962  				cap->issued = cap->implemented = CEPH_CAP_PIN;
> d2f8bb27c87945 Yan, Zheng  2018-12-10  1963  			spin_unlock(&ci->i_ceph_lock);
> d2f8bb27c87945 Yan, Zheng  2018-12-10  1964  		}
> d2f8bb27c87945 Yan, Zheng  2018-12-10  1965  	} else if (ev == FORCE_RO) {
> 0dc2570fab222a Sage Weil   2009-11-20  1966  	}
> e536030934aebf Yan, Zheng  2016-05-19  1967  	wake_up_all(&ci->i_cap_wq);
> 2f2dc053404feb Sage Weil   2009-10-06  1968  	return 0;
> 2f2dc053404feb Sage Weil   2009-10-06  1969  }
>

