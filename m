Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CC455D5E1
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jun 2022 15:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245674AbiF1Igz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Jun 2022 04:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245657AbiF1Igx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 Jun 2022 04:36:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 882F52DAB7
        for <ceph-devel@vger.kernel.org>; Tue, 28 Jun 2022 01:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656405411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dP4tUGmfGPN3oIv7hNqujttiBk+oSSVgVMyBnCUTsRk=;
        b=V/Y09eKKLBctmJbjvf+BE68vGvDNRSeS1vHH/aaBbmAzI1ycKMA5VnZUCPIndXVyqnmJmH
        zLhYyI3KzsCq/z9TF5GMp+gkvmKoeMhXq78OL2axdXPRQYFZezH6AlRzdHxdh7acc3xM2+
        os9a0EAdUoUV9BQCdCuDYyE+oBxI6zE=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-cx5BB7RBM_CD2EcChA5kiA-1; Tue, 28 Jun 2022 04:36:50 -0400
X-MC-Unique: cx5BB7RBM_CD2EcChA5kiA-1
Received: by mail-pg1-f197.google.com with SMTP id 134-20020a63018c000000b0040cf04213a1so6384063pgb.6
        for <ceph-devel@vger.kernel.org>; Tue, 28 Jun 2022 01:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dP4tUGmfGPN3oIv7hNqujttiBk+oSSVgVMyBnCUTsRk=;
        b=j9IS41sGBn+Qhq10eQvq0M3E6ZuKQcO1zCLsUi7CHq/LgNwNeaVH7wf8+slBDNd7O6
         lUdmOrnNP495JfOpVatOEMJOITL0Z5ehJjcWu3xZ10oRxesoFfBlK/k4Psyh6hoBE2Pt
         NwxMhG3rWz73qh9eyGo9LNf0FALieiNSdd9D3iExvjAVaek4Z4WaTBkzZPGaXxSOE43R
         0EMKUbtp2oXxM7Cjw0ijFexAHP2GRerM/UVLrSGkYLHkYwYQHlBYTbjG8lnRZVJWXXgK
         n4be1z5AgxjsNHiMjaFyMIcVcNMOs4FCL+kAy9p0MYXCPqaKTTPMK/5BCMxiqtvE4J1X
         vsmw==
X-Gm-Message-State: AJIora8Xa9F/m4ok7CQmRbFpUVSvkQjAHUlT5Ua3oLqM9nxtp+FxTkdR
        BO4S7jtlN8GdnWwSVb7tfILZ9QWHAbJkXBVwcK1M7X4bTCLKsf9zISKII8h0G6PqTONJvYf2CV3
        KY3C1QU5KQW1vvzzfmX2vaUXPb3HUIwstG3EiuM2T/rnINtmfWkTPFisgrOSmSDfAzsJgOu0=
X-Received: by 2002:a17:902:cecc:b0:16a:416c:3d14 with SMTP id d12-20020a170902cecc00b0016a416c3d14mr2540261plg.73.1656405409086;
        Tue, 28 Jun 2022 01:36:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t7KNjNsIwnoG+fMs/EiLmcAQUGAgMOPRum7wW8TCRorDMbMi1hLSRXfguE6Gjn2Fc2q1wWHg==
X-Received: by 2002:a17:902:cecc:b0:16a:416c:3d14 with SMTP id d12-20020a170902cecc00b0016a416c3d14mr2540228plg.73.1656405408729;
        Tue, 28 Jun 2022 01:36:48 -0700 (PDT)
Received: from [10.72.12.43] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m17-20020a170902db1100b0016a275623c1sm1182919plx.219.2022.06.28.01.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 01:36:47 -0700 (PDT)
Subject: Re: [PATCH v3] ceph/005: verify correct statfs behaviour with quotas
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        fstests@vger.kernel.org
Cc:     David Disseldorp <ddiss@suse.de>, Zorro Lang <zlang@redhat.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20220627102631.5006-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3a0a72f9-6b36-f101-d77e-f5b6e51adc56@redhat.com>
Date:   Tue, 28 Jun 2022 16:36:39 +0800
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

Hi Luis,

BTW, shouldn't you update the 'tests/ceph/group.list' at the same time ?

-- Xiubo

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

