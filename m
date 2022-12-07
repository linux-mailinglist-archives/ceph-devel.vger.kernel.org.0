Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F451645082
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Dec 2022 01:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiLGAl0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Dec 2022 19:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiLGAlT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Dec 2022 19:41:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33805F61
        for <ceph-devel@vger.kernel.org>; Tue,  6 Dec 2022 16:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670373623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PsNujvX/Fn/RGbSU/hjSMEvFUx/g85wLbN26rijJ3vg=;
        b=btC94m0abxrIda5NkghJFmV7PqAKZ+Zu2ZTrSJaRUPVMxtxE7zYTD3x434y1ZCJo8HyKqM
        5zZlmoJLgdY5Ysdo45ZdRdx2Tx8vRJL4KRPorfQZ8eHB3KyzNIaCBaFyXKvlczNW0YJD95
        x7joSuWBBsPu2VBarI3e6pvAkJFAOnc=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-563-Rw68tQzONFm7dlNNmeb2tQ-1; Tue, 06 Dec 2022 19:40:22 -0500
X-MC-Unique: Rw68tQzONFm7dlNNmeb2tQ-1
Received: by mail-pl1-f198.google.com with SMTP id c12-20020a170902d48c00b00189e5443387so4597190plg.15
        for <ceph-devel@vger.kernel.org>; Tue, 06 Dec 2022 16:40:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PsNujvX/Fn/RGbSU/hjSMEvFUx/g85wLbN26rijJ3vg=;
        b=mJnXQQPHH6PjxPGe7p/lBu5GIOBpRpn5m1BU2B7gSKQjLmvlLOZWrp1QH7jWjLQHN+
         VvJGxCHvqlxjNalH29txwprJZ0yk2GA8oklWuU03jOCm/Bz7b8VK7xNmrpB0Cwz4bGly
         5q4+FKkEwi4uCf7yPRyAlGqky4Pb01kINZJnURuQrz/IOTYcgYK42x9mwR/XtCxNzPsa
         dReGrJMxBkbiGMIxWVgCeNliDGNomhccObOaOKWcs857dY4Cu1+Bl02BJl+oTDfPxchy
         1AoNrmGy2H6yqhqhG1riWCfoNxweQYWEoSo+0hXYV6Xvgy/ezar4fODNpOu8jKWHe2fv
         WuJA==
X-Gm-Message-State: ANoB5pm/RpgyCSKL4jXhbMiFnQzygPBTB3/6OF0Vg8gy0u73HUG++Zwg
        btAx1spBGU7TX2xqVG5285LKtFrG4ejN8RE4lv1TDsLcmAIo5BtNqeRVYFDZxXLfuNMIcFNb3zw
        WuU7DSPk07vXAUboyfGAxO/a8SPsZ+PDEPZUwlQ4ZoT1P5xICgzrxARE/58aH2oLVJebvkoM=
X-Received: by 2002:a17:90b:3c91:b0:219:da8f:c6f0 with SMTP id pv17-20020a17090b3c9100b00219da8fc6f0mr11723540pjb.1.1670373620835;
        Tue, 06 Dec 2022 16:40:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7yUd5W2add/mwtbcIS9CcXmW8qGtNWG9jes+aOQbClbGrssboKS1jYedUfuPNCBGJ2beFjHA==
X-Received: by 2002:a17:90b:3c91:b0:219:da8f:c6f0 with SMTP id pv17-20020a17090b3c9100b00219da8fc6f0mr11723502pjb.1.1670373620161;
        Tue, 06 Dec 2022 16:40:20 -0800 (PST)
Received: from [10.72.12.244] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k1-20020a170902c40100b001895b2c4cf6sm13228920plk.297.2022.12.06.16.40.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 16:40:19 -0800 (PST)
Subject: Re: [ceph-client:testing 5/6] fs/ceph/super.c:1486:9: error: no
 member named 's_master_keys' in 'struct super_block'
To:     kernel test robot <lkp@intel.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        ceph-devel@vger.kernel.org
References: <202212070634.i0I0ZtVz-lkp@intel.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <49a4125b-0885-bb00-8d84-ec8329ec7be1@redhat.com>
Date:   Wed, 7 Dec 2022 08:40:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <202212070634.i0I0ZtVz-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thanks for reporting this.

It's just a test patch in the testing branch. And I will fix it.

- Xiubo

On 07/12/2022 07:01, kernel test robot wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   6950ae50f0998ef6846eab505c452c6bf02070e3
> commit: c90f64b588ffb49a67bbf10c0580cf9051ced56a [5/6] [DO NOT MERGE] ceph: make sure all the files successfully put before unmounting
> config: powerpc-randconfig-r016-20221206
> compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 6e4cea55f0d1104408b26ac574566a0e4de48036)
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # install powerpc cross compiling tool for clang build
>          # apt-get install binutils-powerpc-linux-gnu
>          # https://github.com/ceph/ceph-client/commit/c90f64b588ffb49a67bbf10c0580cf9051ced56a
>          git remote add ceph-client https://github.com/ceph/ceph-client.git
>          git fetch --no-tags ceph-client testing
>          git checkout c90f64b588ffb49a67bbf10c0580cf9051ced56a
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash fs/ceph/ mm/
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>>> fs/ceph/super.c:1486:9: error: no member named 's_master_keys' in 'struct super_block'
>             if (s->s_master_keys)
>                 ~  ^
>     1 error generated.
>
>
> vim +1486 fs/ceph/super.c
>
>    1471	
>    1472	static void ceph_kill_sb(struct super_block *s)
>    1473	{
>    1474		struct ceph_fs_client *fsc = ceph_sb_to_client(s);
>    1475	
>    1476		dout("kill_sb %p\n", s);
>    1477	
>    1478		ceph_mdsc_pre_umount(fsc->mdsc);
>    1479		flush_fs_workqueues(fsc);
>    1480	
>    1481		/*
>    1482		 * If the encrypt is enabled we need to make sure the delayed
>    1483		 * fput to finish, which will make sure all the inodes will
>    1484		 * be evicted before removing the encrypt keys.
>    1485		 */
>> 1486		if (s->s_master_keys)
>    1487			flush_delayed_fput();
>    1488	
>    1489		kill_anon_super(s);
>    1490	
>    1491		fsc->client->extra_mon_dispatch = NULL;
>    1492		ceph_fs_debugfs_cleanup(fsc);
>    1493	
>    1494		ceph_fscache_unregister_fs(fsc);
>    1495	
>    1496		destroy_fs_client(fsc);
>    1497	}
>    1498	
>

