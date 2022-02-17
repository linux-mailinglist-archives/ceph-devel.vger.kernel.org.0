Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF81A4B9530
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Feb 2022 01:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiBQA7g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Feb 2022 19:59:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiBQA7e (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Feb 2022 19:59:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F0332740C8
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 16:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645059560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eU/Mifbu4etylHTsMKrowLFS/TabOtITNkaHH9/HGA0=;
        b=ZeM+C4agpiRdBygV5b/qJhle6LZtzd3i19kDKgeLUkTnMOO/A6uHmGMRJFop+D8DMFm0Zq
        shR2QI28EE3NaOJ14EmU660hkKNV8SNAWCYgBq62cRwQyR8etfoTR8zal+LwcEpBSuxOp+
        b7K46e/4zWJOXxr7+jGPHiKM9FGeHBs=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-1dh7Q9U5Nza9p3BqnsIdvQ-1; Wed, 16 Feb 2022 19:59:19 -0500
X-MC-Unique: 1dh7Q9U5Nza9p3BqnsIdvQ-1
Received: by mail-pg1-f197.google.com with SMTP id t68-20020a635f47000000b003732348b971so2052835pgb.7
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 16:59:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=eU/Mifbu4etylHTsMKrowLFS/TabOtITNkaHH9/HGA0=;
        b=mPciJyjxnsKc8ChlBBJWZbyOKNO3/srQRjji+dfUE/tdVRrd6GqgBWFDBY9xzw01ZC
         FNtkcUM586Wf2OGRFKSycHJRXevYYqlpX5otfvm0IWsoUVoJY3nohIMqI/CAyxDDebw2
         P3bbLws7A0xeDD08NlhXxlrtokGV8w2YZSCGjInOQkCdYnbxw8I4NXo7XNBWV0Tkvwv/
         l6p5Gh4/Bp5WB+FJWrAMR8m2HKeXW7RByTbab2ZzUsqmouEh0Rjt3P7QScnlS+Q6GdFH
         u0sh1FfyPRFoo7rqEcbb3iPsVzTfIbk4U6qFsUMRAFxiCgl2GmeDiO6KTLWYOIDBqMMA
         3qOg==
X-Gm-Message-State: AOAM533k4GpWHz90sE3pAL9izm79ZCBWlhE095hb+aF67+kcb3ElFWlu
        LoX6KMpf6Ok7w3SuiUfpFN9pAToJ7bmu7VRpwRqlEf73iCLiThIrtoRY71tJ6bMnqM6WkgtGlpQ
        ZU5ApLRiBQRsaobInD1l63tNBKPLBadRZGx+bgfBcVf3kEiNRxhXnoAf3zR7zytDd1VjlGi8=
X-Received: by 2002:a17:90a:7385:b0:1b9:6492:c107 with SMTP id j5-20020a17090a738500b001b96492c107mr486857pjg.103.1645059558003;
        Wed, 16 Feb 2022 16:59:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxOfRgZ4aDneinmcCs8KxAfjPbb1usuXhIBXsFT/4HhFw/q1qjE01kLH0IDhdmV8ez1iQrMQ==
X-Received: by 2002:a17:90a:7385:b0:1b9:6492:c107 with SMTP id j5-20020a17090a738500b001b96492c107mr486826pjg.103.1645059557613;
        Wed, 16 Feb 2022 16:59:17 -0800 (PST)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s40sm3123007pfg.145.2022.02.16.16.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 16:59:16 -0800 (PST)
Subject: Re: [ceph-client:testing 13/14] fs/ceph/snap.c:438:14: warning:
 variable '_realm' is uninitialized when used here
To:     Jeff Layton <jlayton@kernel.org>, kernel test robot <lkp@intel.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        ceph-devel@vger.kernel.org
References: <202202170318.82LIXBXX-lkp@intel.com>
 <8d84c25fa277988b36969f1d08543aec8183d7c3.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <40416149-19f3-3719-f7ba-1457d305e2a3@redhat.com>
Date:   Thu, 17 Feb 2022 08:59:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <8d84c25fa277988b36969f1d08543aec8183d7c3.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/17/22 3:52 AM, Jeff Layton wrote:
> On Thu, 2022-02-17 at 03:33 +0800, kernel test robot wrote:
>> tree:   https://github.com/ceph/ceph-client.git testing
>> head:   91e59cfc6ca1a2bf594f60474996c71047edd1e5
>> commit: 7c7e63bc9910b15ffd1f791838ff0a919058f97c [13/14] ceph: eliminate the recursion when rebuilding the snap context
>> config: hexagon-randconfig-r005-20220216 (https://download.01.org/0day-ci/archive/20220217/202202170318.82LIXBXX-lkp@intel.com/config)
>> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 0e628a783b935c70c80815db6c061ec84f884af5)
>> reproduce (this is a W=1 build):
>>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>>          chmod +x ~/bin/make.cross
>>          # https://github.com/ceph/ceph-client/commit/7c7e63bc9910b15ffd1f791838ff0a919058f97c
>>          git remote add ceph-client https://github.com/ceph/ceph-client.git
>>          git fetch --no-tags ceph-client testing
>>          git checkout 7c7e63bc9910b15ffd1f791838ff0a919058f97c
>>          # save the config file to linux build tree
>>          mkdir build_dir
>>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash fs/ceph/
>>
>> If you fix the issue, kindly add following tag as appropriate
>> Reported-by: kernel test robot <lkp@intel.com>
>>
>> All warnings (new ones prefixed by >>):
>>
>>>> fs/ceph/snap.c:438:14: warning: variable '_realm' is uninitialized when used here [-Wuninitialized]
>>                             list_del(&_realm->rebuild_item);
>>                                       ^~~~~~
>>     fs/ceph/snap.c:430:33: note: initialize the variable '_realm' to silence this warning
>>                     struct ceph_snap_realm *_realm, *child;
>>                                                   ^
>>                                                    = NULL
>>     1 warning generated.
>>
>>
>> vim +/_realm +438 fs/ceph/snap.c
>>
>>     417	
>>     418	/*
>>     419	 * rebuild snap context for the given realm and all of its children.
>>     420	 */
>>     421	static void rebuild_snap_realms(struct ceph_snap_realm *realm,
>>     422					struct list_head *dirty_realms)
>>     423	{
>>     424		LIST_HEAD(realm_queue);
>>     425		int last = 0;
>>     426	
>>     427		list_add_tail(&realm->rebuild_item, &realm_queue);
>>     428	
>>     429		while (!list_empty(&realm_queue)) {
>>     430			struct ceph_snap_realm *_realm, *child;
>>     431	
>>     432			/*
>>     433			 * If the last building failed dues to memory
>>     434			 * issue, just empty the realm_queue and return
>>     435			 * to avoid infinite loop.
>>     436			 */
>>     437			if (last < 0) {
>>   > 438				list_del(&_realm->rebuild_item);
>>     439				continue;
>>     440			}
>>     441	
>>     442			_realm = list_first_entry(&realm_queue,
>>     443						  struct ceph_snap_realm,
>>     444						  rebuild_item);
> Xiubo, I think we just need to move this assignment of _realm above the
> previous if block. I've made that change in-tree. Please take a look and
> make sure it looks OK to you.
>
Look good to me.

Thanks.

>>     445			last = build_snap_context(_realm, &realm_queue, dirty_realms);
>>     446			dout("rebuild_snap_realms %llx %p, %s\n", _realm->ino, _realm,
>>     447			     last > 0 ? "is deferred" : !last ? "succeeded" : "failed");
>>     448	
>>     449			list_for_each_entry(child, &_realm->children, child_item)
>>     450				list_add_tail(&child->rebuild_item, &realm_queue);
>>     451	
>>     452			/* last == 1 means need to build parent first */
>>     453			if (last <= 0)
>>     454				list_del(&_realm->rebuild_item);
>>     455		}
>>     456	}
>>     457	
>>
>> ---
>> 0-DAY CI Kernel Test Service, Intel Corporation
>> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> Thanks, KTR!

