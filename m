Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF2B655B4AD
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Jun 2022 02:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiF0Af1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Jun 2022 20:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiF0Af0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Jun 2022 20:35:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C8A62AC7
        for <ceph-devel@vger.kernel.org>; Sun, 26 Jun 2022 17:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656290124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JCvGSeoklAqx1gOmUCcWDBPV8GG8i/Hjqb6gxEvBonE=;
        b=VVVG3Nn1Sd9Dyrq6Gr6fDp1lZlD2fRN+ziPVShd+bQniPgdVffpXKeaBHgEcnE/Az3h899
        Vkeh1Qa7227Bo9jDRJdIiu7fU8B/UxksFk2RLpHfeBqrCaNJcY94oYW/VLElJBWg/OuPhB
        AMNcyAGMNh/3sLqTBd+zBgIMqQ5l4Vs=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-8-_oSAsffuPSWvUdS6himxjA-1; Sun, 26 Jun 2022 20:35:22 -0400
X-MC-Unique: _oSAsffuPSWvUdS6himxjA-1
Received: by mail-pf1-f200.google.com with SMTP id bm2-20020a056a00320200b0052531ca7c1cso3250122pfb.15
        for <ceph-devel@vger.kernel.org>; Sun, 26 Jun 2022 17:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=JCvGSeoklAqx1gOmUCcWDBPV8GG8i/Hjqb6gxEvBonE=;
        b=WTdag1PeMZaQ5o3co8YvhnLQZV0VyW25BD/DDlOuuBseWCU6gn/sd/U7pYRfISdGwj
         Ps5aSzDW7s2nzUm6iFa7SBQtm3w3zsBCItOsRbD9nGSUjjd7bC5syFUUJb1uXKPGX62P
         clya6Wdvo8dGNS81Z3C6NkPZuE/uEuPrO22lm1T5QeF8FzkQmrDK45u78NiNox/BiTKj
         SXfUrDW9eVyVt6Y0/mD/5DrASqasjNXO4lsn2dEdHkyJ/oVvoMAv3CQESNkxSjSaUjFv
         rR0+QhxuRvUFkAt2DwpYSdxHl2rRqv4COZoSgv4PvnEUmT3G/85mde7p+EYAnESCozSr
         SZ5w==
X-Gm-Message-State: AJIora+ITqIewpPxvy9YNO95dxfgCAtm6+a4DdRhQBotHx0foxya12Od
        62j6+usuFMIFk53i031CzoF0422JSzgCS3wwwfeyus+x3aTNjNVuZQpoINKoajY1U/G4KJqBvuz
        M5HLK8/YVB/Mxc3p9wo+05K53rYS5zKanBNNgo59FUlmKE9/kPoxacpCW2DWsb8gZqVn9Ft0=
X-Received: by 2002:a17:902:7604:b0:16a:f36d:73f3 with SMTP id k4-20020a170902760400b0016af36d73f3mr4695492pll.170.1656290121224;
        Sun, 26 Jun 2022 17:35:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uz6pwTu7tc4a03NrfPE+qCvw77oO2PMKSAnvj0+WD46YNlNSFk1T7VyKUalEJ+lp6c9dEi6w==
X-Received: by 2002:a17:902:7604:b0:16a:f36d:73f3 with SMTP id k4-20020a170902760400b0016af36d73f3mr4695455pll.170.1656290120857;
        Sun, 26 Jun 2022 17:35:20 -0700 (PDT)
Received: from [10.72.12.43] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902680500b0015e8d4eb20dsm5793791plk.87.2022.06.26.17.35.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jun 2022 17:35:20 -0700 (PDT)
Subject: Re: [PATCH v2] ceph/005: verify correct statfs behaviour with quotas
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        fstests@vger.kernel.org
Cc:     David Disseldorp <ddiss@suse.de>, Zorro Lang <zlang@redhat.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20220615151418.23805-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <1924a7cc-245d-f35b-5e7c-a82f36cf2271@redhat.com>
Date:   Mon, 27 Jun 2022 08:35:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220615151418.23805-1-lhenriques@suse.de>
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

Hi Luis,

Sorry for late.

On 6/15/22 11:14 PM, Luís Henriques wrote:
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
> Finally, I've managed to come back to this test.  The major changes since
> v1 are:
>   - creation of an helper for getting total mount space using 'df'
>   - now the test sends quota size to stdout
>
>   common/rc          | 13 +++++++++++++
>   tests/ceph/005     | 38 ++++++++++++++++++++++++++++++++++++++
>   tests/ceph/005.out |  4 ++++
>   3 files changed, 55 insertions(+)
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
> index 000000000000..7eb687e8a092
> --- /dev/null
> +++ b/tests/ceph/005
> @@ -0,0 +1,38 @@
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
> +SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_mount
> +echo ceph quota size is $(_get_total_space "$SCRATCH_MNT") bytes
> +SCRATCH_DEV="$SCRATCH_DEV/quota-dir" _scratch_unmount
> +

For the 'SCRATCH_DEV' here, if you do:

SCRATCH_DEV="$SCRATCH_DEV/quota-dir"

twice, won't it be "${ceph_scratch_dev}/quota-dir/quota-dir" at last ?

Shouldn't it be:

SCRATCH_DEV="$TEST_DIR/quota-dir" ?

-- Xiubo

> +SCRATCH_DEV="$SCRATCH_DEV/quota-dir/subdir" _scratch_mount
> +echo subdir ceph quota size is $(_get_total_space "$SCRATCH_MNT") bytes
> +SCRATCH_DEV="$SCRATCH_DEV/quota-dir/subdir" _scratch_unmount
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

