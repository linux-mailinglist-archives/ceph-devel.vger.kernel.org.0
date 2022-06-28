Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C41955CF5F
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jun 2022 15:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344489AbiF1JxU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Jun 2022 05:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbiF1JxS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 Jun 2022 05:53:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0B1F2E69C
        for <ceph-devel@vger.kernel.org>; Tue, 28 Jun 2022 02:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656409995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cU/pzpi/XiokrCfOD5l4FITUl6zsqV8T8fPljHRYiow=;
        b=HHiEsygdH6cbq44lnUPvVB48lZ1siMRgrX3lZPGxNFewBEvvkI13j5FyaDuGfx9RGQc/mt
        cuMfy5ON5kf9uub1bNTBFJdCm+FfBSQlIt0rXsQN6Km6WHyiFmRDrlPBXmlfBHK0OxsrA6
        GT8IQerVSlsZ5lSS2BKrMYxFm8lXOhA=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-wakI8-3mNVSpotTbMu8eng-1; Tue, 28 Jun 2022 05:53:14 -0400
X-MC-Unique: wakI8-3mNVSpotTbMu8eng-1
Received: by mail-pf1-f199.google.com with SMTP id a127-20020a624d85000000b00525950b1feeso2884926pfb.0
        for <ceph-devel@vger.kernel.org>; Tue, 28 Jun 2022 02:53:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=cU/pzpi/XiokrCfOD5l4FITUl6zsqV8T8fPljHRYiow=;
        b=Fb28Udqk24hZ8tJMCo6yp7UNW3hxjJJIBL+TekTYeQ6sqNOaqoSMTZAWQ0fAFmsVRQ
         DN8+D1CCNsivf7CuXMGZjTlr4Cpve8MO0uSLbZ4UCgePgw6OFy/Z1C7Hv3AFE1im8V4a
         zus9ogM0VsUo+K5MX+/hDeUXnl+ISscF1PT69ds8z89wcsqHaifBNU35sLzL66imksQk
         dRVYlAo3DnvPGo3xRy3ivgbAizVaduPE7fLNczBMZR5HHYgHACPN8W347E+1eSG/rmkz
         TUodczDJdvM00ok5kRlCLzPUfL7LYdxwPVaOZ06jNPgqT5hNs3KxrlqRaqmQtptatlX3
         Nh/w==
X-Gm-Message-State: AJIora8fP4z8IUWP+tVo78g976huGAmfJA6zST/JHyUfw2iaNpvhKCW1
        8Y+2S8YiJiWEk1IksjqqIJXCb2S/EDRyOQYt6I3ernOW2f+CjkxOj1OVA2KfeEznaa+xeozASAj
        6pwEKX8xwe2Ir5PWOsX8z5muDsZPDKClCjEj3Qaz3isOqDWA2FhoC8FgbwAK6NgFeoiRkWbc=
X-Received: by 2002:a17:903:2445:b0:16a:32da:cc9 with SMTP id l5-20020a170903244500b0016a32da0cc9mr4079870pls.148.1656409992885;
        Tue, 28 Jun 2022 02:53:12 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sYiIzN3g88kD3uymjxETJJRx6L90Xn6n6EmXV3e6YREH6inBBz/2br/V+aW+n5Z7U05XQChQ==
X-Received: by 2002:a17:903:2445:b0:16a:32da:cc9 with SMTP id l5-20020a170903244500b0016a32da0cc9mr4079837pls.148.1656409992528;
        Tue, 28 Jun 2022 02:53:12 -0700 (PDT)
Received: from [10.72.12.43] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f9-20020a170902f38900b0016a51167b75sm8740540ple.286.2022.06.28.02.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 02:53:11 -0700 (PDT)
Subject: Re: [PATCH v3] ceph/005: verify correct statfs behaviour with quotas
To:     Zorro Lang <zlang@redhat.com>
Cc:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        fstests@vger.kernel.org, David Disseldorp <ddiss@suse.de>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20220627102631.5006-1-lhenriques@suse.de>
 <3a0a72f9-6b36-f101-d77e-f5b6e51adc56@redhat.com>
 <20220628085201.p3pkyozrvbrf3vod@zlang-mailbox>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <55d9abfd-13ed-87cb-6036-f5e012ffa904@redhat.com>
Date:   Tue, 28 Jun 2022 17:53:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220628085201.p3pkyozrvbrf3vod@zlang-mailbox>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/28/22 4:52 PM, Zorro Lang wrote:
> On Tue, Jun 28, 2022 at 04:36:39PM +0800, Xiubo Li wrote:
>> Hi Luis,
>>
>> BTW, shouldn't you update the 'tests/ceph/group.list' at the same time ?
> Thanks your review from cephfs side! We don't save group.list in fstests now,
> group.list is generated when building fstests. Group names of a case are
> recorded in the case itself, refer to:
>
>    +_begin_fstest auto quick quota

Okay, get it.

Thanks.

>
> Thanks,
> Zorro
>
>> -- Xiubo
>>
>> On 6/27/22 6:26 PM, Luís Henriques wrote:
>>> When using a directory with 'max_bytes' quota as a base for a mount,
>>> statfs shall use that 'max_bytes' value as the total disk size.  That
>>> value shall be used even when using subdirectory as base for the mount.
>>>
>>> A bug was found where, when this subdirectory also had a 'max_files'
>>> quota, the real filesystem size would be returned instead of the parent
>>> 'max_bytes' quota value.  This test case verifies this bug is fixed.
>>>
>>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>>> ---
>>> Changes since v2:
>>>    - correctly set SCRATCH_DEV, always using its original value
>>>
>>> Changes since v1 are:
>>>    - creation of an helper for getting total mount space using 'df'
>>>    - now the test sends quota size to stdout
>>>
>>>    common/rc          | 13 +++++++++++++
>>>    tests/ceph/005     | 39 +++++++++++++++++++++++++++++++++++++++
>>>    tests/ceph/005.out |  4 ++++
>>>    3 files changed, 56 insertions(+)
>>>    create mode 100755 tests/ceph/005
>>>    create mode 100644 tests/ceph/005.out
>>>
>>> diff --git a/common/rc b/common/rc
>>> index 2f31ca464621..72eabb7a428c 100644
>>> --- a/common/rc
>>> +++ b/common/rc
>>> @@ -4254,6 +4254,19 @@ _get_available_space()
>>>    	echo $((avail_kb * 1024))
>>>    }
>>> +# get the total space in bytes
>>> +#
>>> +_get_total_space()
>>> +{
>>> +	if [ -z "$1" ]; then
>>> +		echo "Usage: _get_total_space <mnt>"
>>> +		exit 1
>>> +	fi
>>> +	local total_kb;
>>> +	total_kb=`$DF_PROG $1 | tail -n1 | awk '{ print $3 }'`
>>> +	echo $(($total_kb * 1024))
>>> +}
>>> +
>>>    # return device size in kb
>>>    _get_device_size()
>>>    {
>>> diff --git a/tests/ceph/005 b/tests/ceph/005
>>> new file mode 100755
>>> index 000000000000..fd71d91350db
>>> --- /dev/null
>>> +++ b/tests/ceph/005
>>> @@ -0,0 +1,39 @@
>>> +#! /bin/bash
>>> +# SPDX-License-Identifier: GPL-2.0
>>> +# Copyright (C) 2022 SUSE Linux Products GmbH. All Rights Reserved.
>>> +#
>>> +# FS QA Test 005
>>> +#
>>> +# Make sure statfs reports correct total size when:
>>> +# 1. using a directory with 'max_byte' quota as base for a mount
>>> +# 2. using a subdirectory of the above directory with 'max_files' quota
>>> +#
>>> +. ./common/preamble
>>> +_begin_fstest auto quick quota
>>> +
>>> +_supported_fs ceph
>>> +_require_scratch
>>> +
>>> +_scratch_mount
>>> +mkdir -p "$SCRATCH_MNT/quota-dir/subdir"
>>> +
>>> +# set quota
>>> +quota=$((2 ** 30)) # 1G
>>> +$SETFATTR_PROG -n ceph.quota.max_bytes -v "$quota" "$SCRATCH_MNT/quota-dir"
>>> +$SETFATTR_PROG -n ceph.quota.max_files -v "$quota" "$SCRATCH_MNT/quota-dir/subdir"
>>> +_scratch_unmount
>>> +
>>> +SCRATCH_DEV_ORIG="$SCRATCH_DEV"
>>> +SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_mount
>>> +echo ceph quota size is $(_get_total_space "$SCRATCH_MNT") bytes
>>> +SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir" _scratch_unmount
>>> +
>>> +SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir/subdir" _scratch_mount
>>> +echo subdir ceph quota size is $(_get_total_space "$SCRATCH_MNT") bytes
>>> +SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir/subdir" _scratch_unmount
>>> +
>>> +echo "Silence is golden"
>>> +
>>> +# success, all done
>>> +status=0
>>> +exit
>>> diff --git a/tests/ceph/005.out b/tests/ceph/005.out
>>> new file mode 100644
>>> index 000000000000..47798b1fcd6f
>>> --- /dev/null
>>> +++ b/tests/ceph/005.out
>>> @@ -0,0 +1,4 @@
>>> +QA output created by 005
>>> +ceph quota size is 1073741824 bytes
>>> +subdir ceph quota size is 1073741824 bytes
>>> +Silence is golden
>>>

