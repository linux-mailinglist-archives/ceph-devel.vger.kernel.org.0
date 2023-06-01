Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC307197B5
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Jun 2023 11:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbjFAJwK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Jun 2023 05:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbjFAJwH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 1 Jun 2023 05:52:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC0E134
        for <ceph-devel@vger.kernel.org>; Thu,  1 Jun 2023 02:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685613076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OzIlMFRG7JVgyYici9Bt6+3TtN9Mm4P63XnmoTugrLk=;
        b=PLGpcG6NlKaAuWCLAM9Bi7uIqw0BYhKOHobG1aplzXo1TA6jsCvh9mbckiW/Kv3DefSvp1
        UNQ4t+G8/6Uq/hpD6alg5XStApTcAw1IB59T2t4s0W7QqAWc6yZzGEzCCShWgLcOHOkoYP
        ojJGJv6FMQ8IEGxvuYobwvceg779wQI=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-JgUvvGOkOHuxlfmNeGj4Fg-1; Thu, 01 Jun 2023 05:51:14 -0400
X-MC-Unique: JgUvvGOkOHuxlfmNeGj4Fg-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-33b4cbdd21aso5394215ab.2
        for <ceph-devel@vger.kernel.org>; Thu, 01 Jun 2023 02:51:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685613074; x=1688205074;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OzIlMFRG7JVgyYici9Bt6+3TtN9Mm4P63XnmoTugrLk=;
        b=OIsHLvTLh1dct9el6pyocw398WMRG+x5bxYCkTKZS5SnfHe2YyrrUcrG+NKvTW9vcc
         wVJCSiU2jUsUiwPyCnSMzVPpP4MtqzKLLAvMoewiKnzPyyimpnvZhB2UT52eeS8oKbSf
         qrIvOQ8Ev8NVeJTuxt1erjdZJ5ORg1ucR/+lzqA6HpZbn23XDv4oE/xueNptXN44B8yq
         Uzl3oNJHYsphafItG/kDP36MPf32NKLxJ9Iw3FUeOrpm+4qPYStlfHkiVARjy18nHRb+
         QloiZrbIYpYLtdfx6e+HdQ7HBjW9hyhJ8X8rCpM2F2RRAqbAAq7NNO8JvASTRiYAVNOc
         jWLA==
X-Gm-Message-State: AC+VfDxn7kAkolkE9pO9WgbXInOnB9PpBk/l2/vcmE+DSP948i5xcZ1A
        mqa9/mLdJbOvDg2OguEcDaIeIxarBI/gOvxlzkDHcA26pJd2Neo34XlUBmWAnPS7biSmwXS84Gh
        OARh+AAucUSyfule8vRJkAw==
X-Received: by 2002:a92:c708:0:b0:33b:abaf:d493 with SMTP id a8-20020a92c708000000b0033babafd493mr5590429ilp.16.1685613073958;
        Thu, 01 Jun 2023 02:51:13 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7qPXazSRAYRxqRw6piwj80oKyUTmO7apVm4+a2/Fd4B4wcVr99CGP2dt0Y2TsYe7FsVLE+DQ==
X-Received: by 2002:a92:c708:0:b0:33b:abaf:d493 with SMTP id a8-20020a92c708000000b0033babafd493mr5590423ilp.16.1685613073692;
        Thu, 01 Jun 2023 02:51:13 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id l7-20020a656807000000b0051416609fb7sm2521765pgt.61.2023.06.01.02.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 02:51:12 -0700 (PDT)
Date:   Thu, 1 Jun 2023 17:51:09 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     xiubli@redhat.com
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] common/rc: skip ceph-fuse when atime is required
Message-ID: <20230601095109.bzdb2nithqngngwd@zlang-mailbox>
References: <20230601025207.857009-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601025207.857009-1-xiubli@redhat.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 01, 2023 at 10:52:07AM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Ceph won't maintain the atime, so just skip the tests when the atime
> is required.
> 
> Fixes: https://tracker.ceph.com/issues/61551
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/rc | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/common/rc b/common/rc
> index 37074371..f3b92741 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -4089,7 +4089,7 @@ _require_atime()
>  	nfs|afs|cifs|virtiofs)
>  		_notrun "atime related mount options have no effect on $FSTYP"
>  		;;
> -	ceph)
> +	ceph|ceph-fuse)
>  		_notrun "atime not maintained by $FSTYP"
>  		;;
>  	esac
> -- 
> 2.40.1
> 

