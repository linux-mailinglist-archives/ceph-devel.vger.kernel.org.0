Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E62364E5F1
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Dec 2022 03:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiLPCVn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Dec 2022 21:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPCVm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 15 Dec 2022 21:21:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14361A397
        for <ceph-devel@vger.kernel.org>; Thu, 15 Dec 2022 18:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671157255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xav16zhn6vX0gfBE351/I3PO3o1hrznXI1GHu611aG8=;
        b=EGfT4Jt0pYbFRQ2HFHVaGa/43yFfC+leQ+VeqpgOW3Fh2dybA/rkbmebkWzfdnAQ8r7oMD
        8C7Xmblh5JLtaLNffXe/uTEYJdE8OZv1yqwPikPBG6vc1ZqhY8UhPAMUfns3oiFHeGv/E+
        rHtVAt+aHyrLEnbppRYqOru6hY1n18U=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-211-YyJAYlcZOZOL4vvtP5I0SQ-1; Thu, 15 Dec 2022 21:20:53 -0500
X-MC-Unique: YyJAYlcZOZOL4vvtP5I0SQ-1
Received: by mail-pj1-f71.google.com with SMTP id z12-20020a17090abd8c00b0021a0a65a7e2so3060768pjr.7
        for <ceph-devel@vger.kernel.org>; Thu, 15 Dec 2022 18:20:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xav16zhn6vX0gfBE351/I3PO3o1hrznXI1GHu611aG8=;
        b=52Y6iBzlN5WxxPsc/S6OdagrwWkBzIWtyDp7jJg1bjidPQD+3wYeZjxvPz6TrbQysB
         EyPXyco4BdGEA05Zce7mRqxHV2SgW5DZk9ZqIppAB7ld1XWgeZhqp3unoKr2OSj1VovX
         traRzrVD+iiqAYzJ16X+mHd9MJASkxVjADP+x3tWG22d4wG+gTxr19hBEb3PwZEO+RIm
         QienlnNylDJgCppXoM2ZNbKheMXXE60U1RV9DDAc6lCxZQ34rY7NZkUmVpTmYkbsKB1m
         eocFo0wKIS34k7Y+THpDiQ7osh2rueWZ2zuerhxnwK8m1pVd26erj8y6V157EcWhrwA1
         joQQ==
X-Gm-Message-State: ANoB5plxXP9Ml5agFMyBh/NRb68Sa+yXdy/Keu7IGEnlezynCljwTkIC
        UrsGssNrtOB6uhcaPyQlTrTvUi1VNgTiG6gzJ9PB6lPJKuyVju8z7BpGnb9miARtstK/H4Pe5QQ
        4rZof/xnPWIJOKzbOGnhMKwGaXHSnD51NH6I5FYG3eLKPijRDZyO1tqHCDw7vspCJfyWN3lY=
X-Received: by 2002:a05:6a20:3b1d:b0:af:6cc0:344d with SMTP id c29-20020a056a203b1d00b000af6cc0344dmr9713633pzh.18.1671157252563;
        Thu, 15 Dec 2022 18:20:52 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6QbZ3Si3x0uc7e0XVnlkA8KloulUPFp3Qk8BE2PouoMejp1Qv51inDt8FFnIwNZPCd1KFiyw==
X-Received: by 2002:a05:6a20:3b1d:b0:af:6cc0:344d with SMTP id c29-20020a056a203b1d00b000af6cc0344dmr9713606pzh.18.1671157252170;
        Thu, 15 Dec 2022 18:20:52 -0800 (PST)
Received: from [10.72.12.85] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ds6-20020a17090b08c600b00218f9bd50c7sm275095pjb.50.2022.12.15.18.20.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 18:20:51 -0800 (PST)
Subject: Re: PROBLEM: CephFS write performance drops by 90%
To:     Ilya Dryomov <idryomov@gmail.com>,
        "Roose, Marco" <marco.roose@mpinat.mpg.de>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
References: <fc2786c0caa7454486ba318a334c97a3@mpinat.mpg.de>
 <CAOi1vP-J_Qu28q4KFOZVXmX1uBNBfOsMZGFuYCEkny+AAoWesQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <4c039a76-b638-98b7-1104-e81857df8bcd@redhat.com>
Date:   Fri, 16 Dec 2022 10:20:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-J_Qu28q4KFOZVXmX1uBNBfOsMZGFuYCEkny+AAoWesQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Roose,

I think this should be similar with 
https://tracker.ceph.com/issues/57898, but it's from 5.15 instead.

Days ago just after Ilya rebased to the 6.1 without changing anything in 
ceph code the xfstest tests were much faster.

I just checked the difference about the 5.4 and 5.4.45 and couldn't know 
what has happened exactly. So please share your test case about this.

- Xiubo

On 15/12/2022 23:32, Ilya Dryomov wrote:
> On Thu, Dec 15, 2022 at 3:22 PM Roose, Marco <marco.roose@mpinat.mpg.de> wrote:
>> Dear Ilya,
>> I'm using Ubuntu and a CephFS mount. I had a more than 90% write performance decrease after changing the kernels main version ( <10MB/s vs. 100-140 MB/s). The problem seems to exist in Kernel major versions starting at v5.4. Ubuntu mainline version v5.4.25 is fine, v5.4.45 (which is next available) is "bad".
> Hi Marco,
>
> What is the workload?
>
>> After a git bisect with the "original" 5.4 kernels I get the following result:
> Can you describe how you performed bisection?  Can you share the
> reproducer you used for bisection?
>
>> ed24820d1b0cbe8154c04189a44e363230ed647e is the first bad commit
>> commit ed24820d1b0cbe8154c04189a44e363230ed647e
>> Author: Ilya Dryomov <idryomov@gmail.com>
>> Date:   Mon Mar 9 12:03:14 2020 +0100
>>
>>      ceph: check POOL_FLAG_FULL/NEARFULL in addition to OSDMAP_FULL/NEARFULL
>>
>>      commit 7614209736fbc4927584d4387faade4f31444fce upstream.
>>
>>      CEPH_OSDMAP_FULL/NEARFULL aren't set since mimic, so we need to consult
>>      per-pool flags as well.  Unfortunately the backwards compatibility here
>>      is lacking:
>>
>>      - the change that deprecated OSDMAP_FULL/NEARFULL went into mimic, but
>>        was guarded by require_osd_release >= RELEASE_LUMINOUS
>>      - it was subsequently backported to luminous in v12.2.2, but that makes
>>        no difference to clients that only check OSDMAP_FULL/NEARFULL because
>>        require_osd_release is not client-facing -- it is for OSDs
>>
>>      Since all kernels are affected, the best we can do here is just start
>>      checking both map flags and pool flags and send that to stable.
>>
>>      These checks are best effort, so take osdc->lock and look up pool flags
>>      just once.  Remove the FIXME, since filesystem quotas are checked above
>>      and RADOS quotas are reflected in POOL_FLAG_FULL: when the pool reaches
>>      its quota, both POOL_FLAG_FULL and POOL_FLAG_FULL_QUOTA are set.
> The only suspicious thing I see in this commit is osdc->lock semaphore
> which is taken for read for a short period of time in ceph_write_iter().
> It's possible that that started interfering with other code paths that
> take that semaphore for write and read-write lock fairness algorithm is
> biting...
>
> Can you confirm the result by manually checking out the previous commit
> and verifying that it's "good"?
>
>      commit 44960e1c39d807cd0023dc7036ee37f105617ebe
>      RDMA/mad: Do not crash if the rdma device does not have a umad interface
>          (commit 5bdfa854013ce4193de0d097931fd841382c76a7 upstream)
>
> Thanks,
>
>                  Ilya
>

