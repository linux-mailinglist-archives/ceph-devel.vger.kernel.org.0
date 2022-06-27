Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3CC55E1C6
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jun 2022 15:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbiF0Jfw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Jun 2022 05:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbiF0Jfw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Jun 2022 05:35:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2CB5B63DC
        for <ceph-devel@vger.kernel.org>; Mon, 27 Jun 2022 02:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656322550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mTogXV8Hmn3KfbJ1GKCRCHZVZdlUrp052V3zDpNKaEI=;
        b=VBqLXQ8UjbnB3jxlRUWnivcDbynhT6q1L/Bahh+l4T+UTCIE5JLQSTQJJB68CNxYMyD2KE
        ZBur2o314YflP5dMW63gcrEsq8lzcGED2LL+8Ou+YgjqLJbCQPGQiX7ZhHa9WIYjOzKA68
        sMIdpY0iQOOhDBzmEXHI2x5Mfz1CqUY=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-x7sRjHFhMzadUVY1IovSvQ-1; Mon, 27 Jun 2022 05:35:40 -0400
X-MC-Unique: x7sRjHFhMzadUVY1IovSvQ-1
Received: by mail-pj1-f72.google.com with SMTP id u6-20020a17090a1d4600b001ec8200fe70so3385405pju.1
        for <ceph-devel@vger.kernel.org>; Mon, 27 Jun 2022 02:35:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mTogXV8Hmn3KfbJ1GKCRCHZVZdlUrp052V3zDpNKaEI=;
        b=PfpOvpTzU9KImqbDRTqSFc6rfjQ5wkxxcDXjlirzsasqETv+vKI29KZSSSK2HQeYuv
         I9oDP2ckIaiGDhq8ayjlze+0fJxcK9uOyadY2i8uyQ2JyTuJyk+0NnBS482GmHiXq1TI
         /qk7cnCgmiHivAoCVDXfpUdh83DEiWnZzMwLX3m7mboSZlv3UOIgR4Ig4TvuZNdIeZM9
         4DYp23CuqFYJ6ZUWV8CwR9/fxzJJDDHpmbbzWItY8IyGbAaATltyLAaKaTC3JhQEGL6w
         jRM5jrkX+0L7nlevtUo29kUq3hbvLiD7RDfz8sVGtebqcIe+zqL+gvOZNlV2+TmHc8ix
         TrRw==
X-Gm-Message-State: AJIora8mc2LM8IMieQ+hJlUU9lSQ/RdPq/BLQZSfJYForPy/FBtodmRe
        NJa5Hlg8vM0DZCbCDrpfSzE1NZihQ2bsQJHRhaB1m8gYBjJVjNIEi3NNn55HaD61aomhasf86iH
        zpMLfm4wNQYoSoiY/BI9NZSNcbiQDa5bKw4C5u4qmhOGMstwLJUIWDRmd9PkbmFMCZMhPNsI=
X-Received: by 2002:a63:fc48:0:b0:40d:ad0a:a868 with SMTP id r8-20020a63fc48000000b0040dad0aa868mr11312740pgk.204.1656322538989;
        Mon, 27 Jun 2022 02:35:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1spBoXRspTPRHF8maWts0jQ/xbQayR7RwWSaUTajDKkgoUC7cZy33f+F2sPnYgK+aURXNkI1Q==
X-Received: by 2002:a63:fc48:0:b0:40d:ad0a:a868 with SMTP id r8-20020a63fc48000000b0040dad0aa868mr11312711pgk.204.1656322538496;
        Mon, 27 Jun 2022 02:35:38 -0700 (PDT)
Received: from [10.72.12.43] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e4-20020a17090301c400b0016a11750b50sm6820945plh.16.2022.06.27.02.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 02:35:37 -0700 (PDT)
Subject: Re: [PATCH v2] ceph/005: verify correct statfs behaviour with quotas
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, David Disseldorp <ddiss@suse.de>,
        Zorro Lang <zlang@redhat.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20220615151418.23805-1-lhenriques@suse.de>
 <1924a7cc-245d-f35b-5e7c-a82f36cf2271@redhat.com> <Yrl2ZXzOcwM6LCLe@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <034326ee-8018-aaeb-c918-efedc8a90eeb@redhat.com>
Date:   Mon, 27 Jun 2022 17:35:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <Yrl2ZXzOcwM6LCLe@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/27/22 5:20 PM, Luís Henriques wrote:
> On Mon, Jun 27, 2022 at 08:35:14AM +0800, Xiubo Li wrote:
>> Hi Luis,
>>
>> Sorry for late.
>>
>> On 6/15/22 11:14 PM, Luís Henriques wrote:
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
>>> Finally, I've managed to come back to this test.  The major changes since
>>> v1 are:
>>>    - creation of an helper for getting total mount space using 'df'
>>>    - now the test sends quota size to stdout
>>>
>>>    common/rc          | 13 +++++++++++++
>>>    tests/ceph/005     | 38 ++++++++++++++++++++++++++++++++++++++
>>>    tests/ceph/005.out |  4 ++++
>>>    3 files changed, 55 insertions(+)
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
>>> index 000000000000..7eb687e8a092
>>> --- /dev/null
>>> +++ b/tests/ceph/005
>>> @@ -0,0 +1,38 @@
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
>>> +SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_mount
>>> +echo ceph quota size is $(_get_total_space "$SCRATCH_MNT") bytes
>>> +SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_unmount
>>> +
>> For the 'SCRATCH_DEV' here, if you do:
>>
>> SCRATCH_DEV="$SCRATCH_DEV/quota-dir"
>>
>> twice, won't it be "${ceph_scratch_dev}/quota-dir/quota-dir" at last ?
>>
>> Shouldn't it be:
>>
>> SCRATCH_DEV="$TEST_DIR/quota-dir" ?
> No, actually we do really need to have $SCRATCH_DEV and not $TEST_DIR
> here, because we want to have SCRATCH_DEV set to something like:
>
> 	<mon-ip-addr>:<port>:/quota-dir
>
> so that we will use that directory (with quotas) as base for the mount.
>
> Regarding the second attribution using the already modifed $SCRATCH_DEV
> variable, that's not really what is happening (and I had to go
> double-check myself, as you got me confused too :-).
>
> So, if you do:
>
> SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_mount
> SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_unmount
>
> the SCRATCH_DEV value is changed *only* for the _scratch_[un]mount
> functions, but SCRATCH_DEV value isn't really changed after these
> attributions.  This is probably a bashism (I'm not really sure), but you
> can see a similar pattern in other places (see, for example, test
> xfs/234).

Sorry, could you give the link about this ?

Checked the xfs/234, I didn't find any place is using the similar pattern.

This is what I see:

  53 # Now restore the obfuscated one back and take a look around
  54 echo "Restore metadump"
  55 xfs_mdrestore $metadump_file $TEST_DIR/image
  56 SCRATCH_DEV=$TEST_DIR/image _scratch_mount
  57 SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
  58
  59 echo "Check restored fs"
  60 _check_generic_filesystem $metadump_file



> Anyway, if you prefer, I'm fine sending v3 of this test doing something
> like:

Locally I just test this use case, it seems working as my guess.

-- Xiubo

>
> SCRATCH_DEV_ORIG="$SCRATCH_DEV"
> SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir" _scratch_mount
> ...
>
> Cheers,
> --
> Luís
>
>> -- Xiubo
>>
>>> +SCRATCH_DEV="$SCRATCH_DEV/quota-dir/subdir" _scratch_mount
>>> +echo subdir ceph quota size is $(_get_total_space "$SCRATCH_MNT") bytes
>>> +SCRATCH_DEV="$SCRATCH_DEV/quota-dir/subdir" _scratch_unmount
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

