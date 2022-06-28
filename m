Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CAE55D953
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jun 2022 15:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244682AbiF1F6b (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Jun 2022 01:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245194AbiF1F63 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 Jun 2022 01:58:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF8ED1BEB0
        for <ceph-devel@vger.kernel.org>; Mon, 27 Jun 2022 22:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656395908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3SNh1I5su84TjBk9ZPRDQHkCRRQEPt012QDwlcQnwSY=;
        b=CUSc9beJGIU/XJ917nqqQ4yr6EiJCtuuLaCPGGE6cJ84HDAfHkQWuTwjmbjbUYYIpyt555
        hetewt6PNmIig7i2B8ZLaqppJakqnPqhjH0r00fzXu0ejSqSQY6StFlVxR5c4xkKEVatoq
        SOuLz0d9VdEWyGME33FWsVAuLIqC7XY=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-kv4a5IagMCeJiMmZBKkcXA-1; Tue, 28 Jun 2022 01:58:26 -0400
X-MC-Unique: kv4a5IagMCeJiMmZBKkcXA-1
Received: by mail-pf1-f198.google.com with SMTP id 189-20020a6216c6000000b005252417051fso4807547pfw.8
        for <ceph-devel@vger.kernel.org>; Mon, 27 Jun 2022 22:58:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=3SNh1I5su84TjBk9ZPRDQHkCRRQEPt012QDwlcQnwSY=;
        b=PQLDq/a00ZtpEcJuLj7ddH1iOGJP9dt1VhGIhaCk7NSV3SMBRxMzKeiHi0NAV1bGvJ
         8mxrIdH++nDQfrZW4RdYI6ouceRqhjl5ynm1AZlVmkd+re5seFjaTGUBClDw/e0bxka1
         17M7b+8WjNky6LZoT+DKqCgX11cjHImee+Eg4u7uvPvidVmMNVxJr8jw3XT/WVwxUuw6
         xM+Di+PeAgiuHOv6by8E0RZsbxTWtMJ/oGb1Tfd+gF80m3hFj2uWYF3Agg46oHlDt9bo
         yf7OPEjvZOJv4DcEgbzrg3S5tEVwiej9u0Ct7xuBjatgApbt3o6smZluA/xBTyfSCUXN
         I6SQ==
X-Gm-Message-State: AJIora9UDqyjM1vVAyc1Rdn3fVqbYKgBwRFCyx3YgfhrHmoyy0GFjfJ0
        amco9l6HRvZp+2Qk4cnXiWlji5kcZiMtZDNj5j1GoD6Oa2uPOxHjbXDj1HJovhhGlsMEn6vHC/7
        ASGTL/5WhC5mG4/p1S+3ijrg4+z2kAdImI8JED8kVTjnSj06rK2noZubPv9k0LiyjPwGJCXc=
X-Received: by 2002:a17:90a:ca0f:b0:1ee:d4ab:1f41 with SMTP id x15-20020a17090aca0f00b001eed4ab1f41mr12026137pjt.165.1656395904864;
        Mon, 27 Jun 2022 22:58:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u2YDofdT2zT0IOV8lwDlXck0Cav5Y9E0EKFu3ZTda1PAZy0r46+gTQgCeQXHratAUpWaGdNA==
X-Received: by 2002:a17:90a:ca0f:b0:1ee:d4ab:1f41 with SMTP id x15-20020a17090aca0f00b001eed4ab1f41mr12026099pjt.165.1656395904418;
        Mon, 27 Jun 2022 22:58:24 -0700 (PDT)
Received: from [10.72.12.43] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e17-20020a170902d39100b0016a3db5d608sm8230557pld.289.2022.06.27.22.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 22:58:23 -0700 (PDT)
Subject: Re: [PATCH v3] ceph/005: verify correct statfs behaviour with quotas
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        fstests@vger.kernel.org
Cc:     David Disseldorp <ddiss@suse.de>, Zorro Lang <zlang@redhat.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20220627102631.5006-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d267150e-88d9-00dc-6fce-5ce7bd957cf1@redhat.com>
Date:   Tue, 28 Jun 2022 13:58:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220627102631.5006-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/27/22 6:26 PM, Luís Henriques wrote:
> When using a directory with 'max_bytes' quota as a base for a mount,
> statfs shall use that 'max_bytes' value as the total disk size.  That
> value shall be used even when using subdirectory as base for the mount.
>
> A bug was found where, when this subdirectory also had a 'max_files'
> quota, the real filesystem size would be returned instead of the parent
> 'max_bytes' quota value.  This test case verifies this bug is fixed.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
> Changes since v2:
>   - correctly set SCRATCH_DEV, always using its original value
>
> Changes since v1 are:
>   - creation of an helper for getting total mount space using 'df'
>   - now the test sends quota size to stdout
>
>   common/rc          | 13 +++++++++++++
>   tests/ceph/005     | 39 +++++++++++++++++++++++++++++++++++++++
>   tests/ceph/005.out |  4 ++++
>   3 files changed, 56 insertions(+)
>   create mode 100755 tests/ceph/005
>   create mode 100644 tests/ceph/005.out
>
> diff --git a/common/rc b/common/rc
> index 2f31ca464621..72eabb7a428c 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4254,6 +4254,19 @@ _get_available_space()
>   	echo $((avail_kb * 1024))
>   }
>   
> +# get the total space in bytes
> +#
> +_get_total_space()
> +{
> +	if [ -z "$1" ]; then
> +		echo "Usage: _get_total_space <mnt>"
> +		exit 1
> +	fi
> +	local total_kb;
> +	total_kb=`$DF_PROG $1 | tail -n1 | awk '{ print $3 }'`
> +	echo $(($total_kb * 1024))
> +}
> +
>   # return device size in kb
>   _get_device_size()
>   {
> diff --git a/tests/ceph/005 b/tests/ceph/005
> new file mode 100755
> index 000000000000..fd71d91350db
> --- /dev/null
> +++ b/tests/ceph/005
> @@ -0,0 +1,39 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2022 SUSE Linux Products GmbH. All Rights Reserved.
> +#
> +# FS QA Test 005
> +#
> +# Make sure statfs reports correct total size when:
> +# 1. using a directory with 'max_byte' quota as base for a mount
> +# 2. using a subdirectory of the above directory with 'max_files' quota
> +#
> +. ./common/preamble
> +_begin_fstest auto quick quota
> +
> +_supported_fs ceph
> +_require_scratch
> +
> +_scratch_mount
> +mkdir -p "$SCRATCH_MNT/quota-dir/subdir"
> +
> +# set quota
> +quota=$((2 ** 30)) # 1G
> +$SETFATTR_PROG -n ceph.quota.max_bytes -v "$quota" "$SCRATCH_MNT/quota-dir"
> +$SETFATTR_PROG -n ceph.quota.max_files -v "$quota" "$SCRATCH_MNT/quota-dir/subdir"
> +_scratch_unmount
> +
> +SCRATCH_DEV_ORIG="$SCRATCH_DEV"
> +SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_mount
> +echo ceph quota size is $(_get_total_space "$SCRATCH_MNT") bytes
> +SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir" _scratch_unmount
> +
> +SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir/subdir" _scratch_mount
> +echo subdir ceph quota size is $(_get_total_space "$SCRATCH_MNT") bytes
> +SCRATCH_DEV="$SCRATCH_DEV_ORIG/quota-dir/subdir" _scratch_unmount
> +
> +echo "Silence is golden"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/ceph/005.out b/tests/ceph/005.out
> new file mode 100644
> index 000000000000..47798b1fcd6f
> --- /dev/null
> +++ b/tests/ceph/005.out
> @@ -0,0 +1,4 @@
> +QA output created by 005
> +ceph quota size is 1073741824 bytes
> +subdir ceph quota size is 1073741824 bytes
> +Silence is golden
>
LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


