Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44404DA93A
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Mar 2022 05:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353514AbiCPERO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Mar 2022 00:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237958AbiCPERM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Mar 2022 00:17:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D4B14EA0A
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 21:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647404159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eDoYPAy01A61xr8sauCawT+mFpE5bzER6kryhuKGxrM=;
        b=Wdedo4r9gK/m+TKFsyD/ops+g6yKrPEnYHRemV9kBZPyIIg+VQZfLrGcHP1FXQHxq5ldQE
        MnEVsZmJ8eWEI25k486wmrr/Qq3OAbKhe23ETzIMM9KilX5I0rHngkUgmeEx6VTXR5Y5HY
        qap8MVgWt1Sx04+kZJ7fbETEJped3yc=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-ULOkehxDMWm2D2l2oOALMA-1; Wed, 16 Mar 2022 00:15:57 -0400
X-MC-Unique: ULOkehxDMWm2D2l2oOALMA-1
Received: by mail-lj1-f198.google.com with SMTP id 20-20020a05651c009400b002462f08f8d2so411265ljq.2
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 21:15:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eDoYPAy01A61xr8sauCawT+mFpE5bzER6kryhuKGxrM=;
        b=PXDA9EO+ViHQBo37m8/LNydQ4tY0c+5wCfrTjcDoGz7AEtgjRUGmo16b7p06GAuNqz
         w6tVstmn864H4w+kTP3RyiswRBF7Ri4UYfGGMkJ9sHuH165hj84XkPONaumtx7A20koP
         ToQZiPLQ1zisobnzIgH2l1DzJGdhhpUOP9a2RWP8F5BSRVM03BO+DhxrbA8iMRIBOLPD
         wligUPmr31XOQliST1n8fj+1pdZXyztNBN7K8Mti5vReacHp3iel6XYWG7zEp0iN2T0n
         bbtUCdShBPYDu/rORksFAMDpP9Hy39bJOsdLQVSDB1/CDUL3hGisMDlYoKtLl/y1+ugy
         PkTg==
X-Gm-Message-State: AOAM533IjSC4Nh9Lq69dQ/RTwf54daXegQ9Ae1aUthAvxROv/TO8oSXu
        El+YlDudZCPsEuU/sw6IU9Zu15tbNx1QCu7tpPekd84adqoohVi/JgYN1J8bcNB1C741fQZsqFH
        iOp6gc/k4RVmBfZ3VEjiIjiHs5dtixEtR/uDQVg==
X-Received: by 2002:a05:6512:1105:b0:448:8f4e:d5d0 with SMTP id l5-20020a056512110500b004488f4ed5d0mr8669761lfg.182.1647404155706;
        Tue, 15 Mar 2022 21:15:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylmE5hcl9rBIqjdVQ7Vhwol65nPXl2Ia/kzQh1voHUnZXwgWYd3p6pGUrqwN+SC9NiEgoPrHCprTL+cj3GM20=
X-Received: by 2002:a05:6512:1105:b0:448:8f4e:d5d0 with SMTP id
 l5-20020a056512110500b004488f4ed5d0mr8669751lfg.182.1647404155481; Tue, 15
 Mar 2022 21:15:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220316035100.68406-1-xiubli@redhat.com>
In-Reply-To: <20220316035100.68406-1-xiubli@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Wed, 16 Mar 2022 09:45:18 +0530
Message-ID: <CACPzV1=rWqm1uL1V0eiT6YH+Wkc2FNgZ7y8EkUz2FQZb1cKFaw@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix the buf size and use NAME_SIZE instead
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Luis Henriques <lhenriques@suse.de>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Mar 16, 2022 at 9:21 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Since the base64_encrypted file name shouldn't exceed the NAME_SIZE,
> no need to allocate a buffer from the stack that long.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> Jeff, you can just squash this into the previous commit.
>
>
>  fs/ceph/mds_client.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index c51b07ec72cf..cd0c780a6f84 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2579,7 +2579,7 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for
>                         parent = dget_parent(cur);
>                 } else {
>                         int len, ret;
> -                       char buf[FSCRYPT_BASE64URL_CHARS(NAME_MAX)];
> +                       char buf[NAME_MAX];
>
>                         /*
>                          * Proactively copy name into buf, in case we need to present
> --
> 2.27.0
>

Makes sense.

Acked-by: Venky Shankar <vshankar@redhat.com>

-- 
Cheers,
Venky

