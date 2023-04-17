Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7DEA6E3E6C
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 06:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjDQESx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Apr 2023 00:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjDQESr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Apr 2023 00:18:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22A42716
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 21:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681705079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gTKZwDH0IFVf7f2p+Aqnass2h7qOP94Q4Xm+kge/09I=;
        b=QtWthj5emDTj2WBYNqCdZYiczfdmzCWuQ7joig5vOB0i+hlMbjTXEcZpHVMeeNA0hDaeMD
        HQzQfR/M8I1vUvbkUPpk/fZmyd6P2VHKE3uw0+Ian+sTiDaNxdPFRw1hmnpA+4FTRZaDFf
        r5g8qB23dSL7bgxWqerwUIUnDWq2TGo=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-mZXQcTXdOi2ND2e8LxNExQ-1; Mon, 17 Apr 2023 00:17:58 -0400
X-MC-Unique: mZXQcTXdOi2ND2e8LxNExQ-1
Received: by mail-pl1-f200.google.com with SMTP id m20-20020a170902c45400b001a641823abdso10315699plm.18
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 21:17:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681705077; x=1684297077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gTKZwDH0IFVf7f2p+Aqnass2h7qOP94Q4Xm+kge/09I=;
        b=YvInLKYIkfO6blnsaDF/l/OjjR0hqQxj3HbX/N1GqAAyHuX4aJQY364idVYPLgT/lf
         7smL2w6OVZikMilp3b74h42hUhkk/v+mV2COQR3+Xnf9UE71OaQwMGsn8XXhgU1KU5yB
         1hZBuu1rDH7QljonBgIRQed4gl74yKsuOzijJrWJBbd7vERZoxmcJXMmIlDxmZKg7OgW
         VdPJYN1YVioy2dBzrFcaDC3j5PJ3x/ASTmbtupHSOWU4+48HYYCkfJtXzBdI3c2wWS05
         UbhEXzROwr4L8k0QkjyhHroyksMtCSC5nkm3k4xCuxKuWms/BaFJZLqh/X6u7yhsE+eZ
         69/A==
X-Gm-Message-State: AAQBX9eHdZgdgCcXE/tgXGV0BimB3vM7f+8gCT/uP7t7QZKKUb/BTq7m
        EGjYm1kXg4l4ETG9+yLAz+i7uhGcPr+2viX8mMl4NvAY3JTBib+YpcQ2ShIZRR18HkJ73jHyrlq
        XNoFkNTF0v4HBTrCwPdoODQ==
X-Received: by 2002:a17:902:d508:b0:1a6:8548:e0ac with SMTP id b8-20020a170902d50800b001a68548e0acmr10761457plg.34.1681705077152;
        Sun, 16 Apr 2023 21:17:57 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZbKjyLtyvNF+IoVxnJ78aDG00iKDfpupyVF+feaHzci55dnAf9h4gXD1Bb9MojQnYAr2r5sg==
X-Received: by 2002:a17:902:d508:b0:1a6:8548:e0ac with SMTP id b8-20020a170902d50800b001a68548e0acmr10761445plg.34.1681705076791;
        Sun, 16 Apr 2023 21:17:56 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m7-20020a1709026bc700b0019a5aa7eab0sm6582990plt.54.2023.04.16.21.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 21:17:56 -0700 (PDT)
Date:   Mon, 17 Apr 2023 12:17:52 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     xiubli@redhat.com
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] common/rc: skip ceph when atime is required
Message-ID: <20230417041752.lryihlt7atnljfzo@zlang-mailbox>
References: <20230417024134.30560-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417024134.30560-1-xiubli@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Apr 17, 2023 at 10:41:34AM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Ceph won't maintain the atime, so just skip the tests when the atime
> is required.
> 
> URL: https://tracker.ceph.com/issues/53844
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  common/rc | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 90749343..3238842e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3999,6 +3999,9 @@ _require_atime()
>  	nfs|cifs|virtiofs)
>  		_notrun "atime related mount options have no effect on $FSTYP"
>  		;;
> +	ceph)
> +                _notrun "atime not maintained by $FSTYP"

Make sense to me. I'll change this line a bit when I merge it, to keep the line
aligned (with above).

Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

> +		;;
>  	esac
>  
>  }
> -- 
> 2.39.1
> 

