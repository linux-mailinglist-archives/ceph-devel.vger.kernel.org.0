Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3B24DA945
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Mar 2022 05:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345722AbiCPEcA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Mar 2022 00:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239410AbiCPEb7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Mar 2022 00:31:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A5EA75C853
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 21:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647405045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HZ2IFsPPNdF/502SW7DAQT276+BQSKSIt/oADGmF5rI=;
        b=NczNVCtAk82dWP68CaK5HC4NvmycNdBN5rK127Bc0PqmdHbZLl54jA1r+tn2DAPj3API/F
        R0JXaUOumxRCGU5Eoe4NJ2v+WvtUhxdhmLV+GQFdRQsq5Edng+FM7JOOurds6isHs2H8Hv
        2TsuFhs6eahT2uLc3P6ZplyKKzk9g4M=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-Po8Z0LBvPdq-79w7mYHhSw-1; Wed, 16 Mar 2022 00:30:44 -0400
X-MC-Unique: Po8Z0LBvPdq-79w7mYHhSw-1
Received: by mail-pj1-f70.google.com with SMTP id mm2-20020a17090b358200b001bf529127dfso948944pjb.6
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 21:30:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=HZ2IFsPPNdF/502SW7DAQT276+BQSKSIt/oADGmF5rI=;
        b=eyLi8eLufzKCLDlWi6K0FfZG+zKeoCIpTG4MXl69Zg1ii2MpojmaD6uquc+1xJBcXg
         DVZI+pMlaQWxGb2WrqTTZ78hAxnYaBkKERlqjenS7wDzMZ5ZvdoTDsexIDhr8RPCgAe/
         n/07cR/m6JTG3NEpsIoCYA/cr7U+A1enaXsbuY2W17XnN4QtvNcaYLlSK2VBcTTBxCcd
         wPSlliPhwlzoZHb7i65WvZ45SMroJuNb2tVVMNRs7AyfQo9k9LxAApBXi16SOMc7pJVY
         R4TBCHkryJkVnOG91TBOp7lAjKQYmlNViYu9kB0nuB4yDb4m9HbIsZER0hiNf8xcqejH
         JkCA==
X-Gm-Message-State: AOAM5307dJTs9zaTKDRgItZlEGCVe1M4p9vIWMy951525JLiXurY4ujH
        JqMxkEjv3ZzsVt83Wi2yVGVjYl/55VzsmQlvCkM6/IiAci3QU8hslGXmqrCen3Ow9TTEcL74ZLW
        Bu08IPguc0eJPis8Jv6OwLQ==
X-Received: by 2002:a63:fa0d:0:b0:372:d581:e84 with SMTP id y13-20020a63fa0d000000b00372d5810e84mr26733856pgh.414.1647405043012;
        Tue, 15 Mar 2022 21:30:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgylGeYsq9g5RiPEEBKkILwMKkQww2/4rucnP0p+3mPm10kUzQGj0EERtysf+Y8F2zPoGTxQ==
X-Received: by 2002:a63:fa0d:0:b0:372:d581:e84 with SMTP id y13-20020a63fa0d000000b00372d5810e84mr26733843pgh.414.1647405042683;
        Tue, 15 Mar 2022 21:30:42 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i6-20020a633c46000000b003817d623f72sm861644pgn.24.2022.03.15.21.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 21:30:42 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: get snap_rwsem read lock in handle_cap_export
 for ceph_add_cap
To:     Niels Dossche <dossche.niels@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
References: <20220315152946.12912-1-dossche.niels@gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <dc8bd448-1f2e-bc65-0275-6a6a1239f5d8@redhat.com>
Date:   Wed, 16 Mar 2022 12:30:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220315152946.12912-1-dossche.niels@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/15/22 11:29 PM, Niels Dossche wrote:
> ceph_add_cap says in its function documentation that the caller should
> hold the read lock on the session snap_rwsem. Furthermore, not only
> ceph_add_cap needs that lock, when it calls to ceph_lookup_snap_realm it
> eventually calls ceph_get_snap_realm which states via lockdep that
> snap_rwsem needs to be held. handle_cap_export calls ceph_add_cap
> without that mdsc->snap_rwsem held. Thus, since ceph_get_snap_realm
> and ceph_add_cap both need the lock, the common place to acquire that
> lock is inside handle_cap_export.
>
> Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
> ---
>   fs/ceph/caps.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index b472cd066d1c..a23cf2a528bc 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3856,6 +3856,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>   	dout("handle_cap_export inode %p ci %p mds%d mseq %d target %d\n",
>   	     inode, ci, mds, mseq, target);
>   retry:
> +	down_read(&mdsc->snap_rwsem);
>   	spin_lock(&ci->i_ceph_lock);
>   	cap = __get_cap_for_mds(ci, mds);
>   	if (!cap || cap->cap_id != le64_to_cpu(ex->cap_id))
> @@ -3919,6 +3920,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>   	}
>   
>   	spin_unlock(&ci->i_ceph_lock);
> +	up_read(&mdsc->snap_rwsem);
>   	mutex_unlock(&session->s_mutex);
>   
>   	/* open target session */
> @@ -3944,6 +3946,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>   
>   out_unlock:
>   	spin_unlock(&ci->i_ceph_lock);
> +	up_read(&mdsc->snap_rwsem);
>   	mutex_unlock(&session->s_mutex);
>   	if (tsession) {
>   		mutex_unlock(&tsession->s_mutex);

Reviewed-by: Xiubo Li <xiubli@redhat.com>


