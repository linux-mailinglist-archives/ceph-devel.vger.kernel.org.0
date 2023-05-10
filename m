Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B562E6FDBE1
	for <lists+ceph-devel@lfdr.de>; Wed, 10 May 2023 12:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236542AbjEJKpv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 May 2023 06:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236707AbjEJKpS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 10 May 2023 06:45:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3CF7D93
        for <ceph-devel@vger.kernel.org>; Wed, 10 May 2023 03:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683715470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xDDVqBpm+gKlv4g7hoVUXAiRvqnPVmg7Iyfp3eI/gzI=;
        b=AsdRbC+gATiddzeeKQrrFa8fq2AsRupMESpsAQvQE45gWi130ie2LqYoOPpEukve0aJzSU
        bzM9JJL0MJ+C8nB20bJAP7MJLbp0IHb8PfFF0bR5BkvX8t3KxqHZKC4OKD7rPfRZ1EAU4e
        WV8qiixiwvlNLwQwCw5t8qVypDctS3M=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-_bHY9s9rM22T_QZDuZG-Ig-1; Wed, 10 May 2023 06:44:29 -0400
X-MC-Unique: _bHY9s9rM22T_QZDuZG-Ig-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-24e015fcf81so4060602a91.3
        for <ceph-devel@vger.kernel.org>; Wed, 10 May 2023 03:44:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683715468; x=1686307468;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xDDVqBpm+gKlv4g7hoVUXAiRvqnPVmg7Iyfp3eI/gzI=;
        b=CTpZl0k7pCDrtM7mWQ/0WEJeX5djC6JlY0g3nwCofgXQQzkWCEmhxrSs1XtdF+vOZG
         C/DkqJGTHXw3rOWFOB9F6EsXKWFjMfa6T/U1KUL9nzGGBo6RhP9ZsRS2LKLXEWmQtStd
         5eCQc3OsprgztRfTE6hjyRutoyQeQALGVFdp3uCBXCq0kUqHWZ1PiOTW5p2dFWRfl+YE
         qpGj/6CxrHAXd7CnWCziqGu4Nff3Xn/Z8Qg9PbZrQw2p1L/JTl8Mlkke/mtMIFgaUpmw
         RaoPcbo7vw8FRnIY4yva9eAoIyAiEhFK1w+i8fCExDU57wmN3R3j8WSFnt4ixPdBrxv4
         E6SA==
X-Gm-Message-State: AC+VfDw5FBeFOli2CWNpqTnQV64mQi8yLAXfci8r941XtFQwPlAsd+IQ
        aPeDEGq6W+fzGTU8HJCfEVPH/qKP8O8cOtgYHV/oARMf/mVscjZgQQlyY/XgO9Xtx906JvsW8r6
        O1rSiAzQYxJbh8Ad1g2vvng==
X-Received: by 2002:a17:90b:198c:b0:244:9385:807f with SMTP id mv12-20020a17090b198c00b002449385807fmr16517410pjb.44.1683715468560;
        Wed, 10 May 2023 03:44:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7gWONIci3s8j5j7B12WKMRSkcn+04+6KbMaQgM8jsKodB13D93yv4PInb4Gr5y5GsoZ37z4g==
X-Received: by 2002:a17:90b:198c:b0:244:9385:807f with SMTP id mv12-20020a17090b198c00b002449385807fmr16517393pjb.44.1683715468221;
        Wed, 10 May 2023 03:44:28 -0700 (PDT)
Received: from [10.72.12.156] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id jx12-20020a17090b46cc00b0024e0141353dsm13278970pjb.28.2023.05.10.03.44.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 May 2023 03:44:27 -0700 (PDT)
Message-ID: <e235d9ce-2436-f82f-5392-3a380d38eb35@redhat.com>
Date:   Wed, 10 May 2023 18:44:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 3/3] libceph: reject mismatching name and fsid
Content-Language: en-US
To:     =?UTF-8?B?6IOh546u5paH?= <huww98@outlook.com>
Cc:     ceph-devel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <TYCP286MB2066D19A68A9176E289BB4FDC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <00479efd-529e-0b98-7f45-3d6c97f0e281@redhat.com>
 <TYCP286MB2066015566DE132BA5B3CF06C0779@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <TYCP286MB2066015566DE132BA5B3CF06C0779@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/10/23 16:44, 胡玮文 wrote:
> On Wed, May 10, 2023 at 03:02:09PM +0800, Xiubo Li wrote:
>> On 5/8/23 01:55, Hu Weiwen wrote:
>>> From: Hu Weiwen <sehuww@mail.scut.edu.cn>
>>>
>>> These are present in the device spec of cephfs. So they should be
>>> treated as immutable.  Also reject `mount()' calls where options and
>>> device spec are inconsistent.
>>>
>>> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
>>> ---
>>>    net/ceph/ceph_common.c | 26 +++++++++++++++++++++-----
>>>    1 file changed, 21 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
>>> index 4c6441536d55..c59c5ccc23a8 100644
>>> --- a/net/ceph/ceph_common.c
>>> +++ b/net/ceph/ceph_common.c
>>> @@ -440,17 +440,33 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
>>>    		break;
>>>    	case Opt_fsid:
>>> -		err = ceph_parse_fsid(param->string, &opt->fsid);
>>> +	{
>> BTW, do we need the '{}' here ?
> I want to declare 'fsid' variable closer to its usage.  But a declaration
> cannot follow a case label:
>    
>    error: a label can only be part of a statement and a declaration is not a statement
>
> searching for 'case \w+:\n\s+\{' in the source tree reveals about 1400
> such usage.  Should be pretty common.

Did you see this when compiling ? So odd I jsut remove them and it 
worked for me.


>>> +		struct ceph_fsid fsid;
>>> +
>>> +		err = ceph_parse_fsid(param->string, &fsid);
>>>    		if (err) {
>>>    			error_plog(&log, "Failed to parse fsid: %d", err);
>>>    			return err;
>>>    		}
>>> -		opt->flags |= CEPH_OPT_FSID;
>>> +
>>> +		if (!(opt->flags & CEPH_OPT_FSID)) {
>>> +			opt->fsid = fsid;
>>> +			opt->flags |= CEPH_OPT_FSID;
>>> +		} else if (ceph_fsid_compare(&opt->fsid, &fsid)) {
>>> +			error_plog(&log, "fsid already set to %pU",
>>> +				   &opt->fsid);
>>> +			return -EINVAL;
>>> +		}
>>>    		break;
>>> +	}
>>>    	case Opt_name:
>>> -		kfree(opt->name);
>>> -		opt->name = param->string;
>>> -		param->string = NULL;
>>> +		if (!opt->name) {
>>> +			opt->name = param->string;
>>> +			param->string = NULL;
>>> +		} else if (strcmp(opt->name, param->string)) {
>>> +			error_plog(&log, "name already set to %s", opt->name);
>>> +			return -EINVAL;
>>> +		}
>>>    		break;
>>>    	case Opt_secret:
>>>    		ceph_crypto_key_destroy(opt->key);

