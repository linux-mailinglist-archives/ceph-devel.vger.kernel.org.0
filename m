Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A17E6A46CF
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 17:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjB0QPC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Feb 2023 11:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbjB0QPA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Feb 2023 11:15:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4F71CF60
        for <ceph-devel@vger.kernel.org>; Mon, 27 Feb 2023 08:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677514457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N2XcQO9zBwNgY0UbCQHG/R6/WyIMUta34CRwnHspZKs=;
        b=N8Sa6okyXX/dwEhGc5/TENQGvh/okSNwuz+X+D9vHKPcetkUF9rCd0mf/iKiAse/V778VE
        oQq72v3NmBCUVrx1FtTxE58ur9gyW/K/jFnNh+V7HXxvQ3O9iVdNS/m939FTnmjKe8keZq
        2qkq5p87TbUZpcvBlXxG59JSaUQFFJE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-Lv7xNEOnOtCFmxNszDCDlA-1; Mon, 27 Feb 2023 11:14:14 -0500
X-MC-Unique: Lv7xNEOnOtCFmxNszDCDlA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B18AC8828C4;
        Mon, 27 Feb 2023 16:14:13 +0000 (UTC)
Received: from redhat.com (unknown [10.22.33.100])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 567BA492B12;
        Mon, 27 Feb 2023 16:14:13 +0000 (UTC)
Date:   Mon, 27 Feb 2023 10:14:11 -0600
From:   Bill O'Donnell <billodo@redhat.com>
To:     xiubli@redhat.com
Cc:     fstests@vger.kernel.org, david@fromorbit.com, djwong@kernel.org,
        ceph-devel@vger.kernel.org, vshankar@redhat.com, zlang@redhat.com
Subject: Re: [PATCH v2] generic/020: fix really long attr test failure for
 ceph
Message-ID: <Y/zW074aOKP3PLBh@redhat.com>
References: <20230227041358.350309-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227041358.350309-1-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Feb 27, 2023 at 12:13:58PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If the CONFIG_CEPH_FS_SECURITY_LABEL is enabled the kernel ceph
> itself will set the security.selinux extended attribute to MDS.
> And it will also eat some space of the total size.
> 
> Fixes: https://tracker.ceph.com/issues/58742
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---

LGTM
Reviewed-by Bill O'Donnell <bodonnel@redhat.com>

> 
> V2:
> - make the 'size' and the 'selinux_size' to be local
> 
>  tests/generic/020 | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/generic/020 b/tests/generic/020
> index be5cecad..538a24c6 100755
> --- a/tests/generic/020
> +++ b/tests/generic/020
> @@ -150,9 +150,11 @@ _attr_get_maxval_size()
>  		# it imposes a maximum size for the full set of xattrs
>  		# names+values, which by default is 64K.  Compute the maximum
>  		# taking into account the already existing attributes
> -		max_attrval_size=$(getfattr --dump -e hex $filename 2>/dev/null | \
> +		local size=$(getfattr --dump -e hex $filename 2>/dev/null | \
>  			awk -F "=0x" '/^user/ {len += length($1) + length($2) / 2} END {print len}')
> -		max_attrval_size=$((65536 - $max_attrval_size - $max_attrval_namelen))
> +		local selinux_size=$(getfattr -n 'security.selinux' --dump -e hex $filename 2>/dev/null | \
> +			awk -F "=0x" '/^security/ {len += length($1) + length($2) / 2} END {print len}')
> +		max_attrval_size=$((65536 - $size - $selinux_size - $max_attrval_namelen))
>  		;;
>  	*)
>  		# Assume max ~1 block of attrs
> -- 
> 2.31.1
> 

