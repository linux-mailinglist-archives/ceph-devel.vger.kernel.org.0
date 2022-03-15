Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853D14D960D
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Mar 2022 09:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345829AbiCOIU6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Mar 2022 04:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345827AbiCOIU6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Mar 2022 04:20:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F32B84BFEB
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 01:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647332386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3uXmagTXpajgb16CBvtp/WGdSbWtbXyqqh5a7pgAtr8=;
        b=T/o7pYQ0OkXORvy7Z802IEO68W+zoDRE/gIVJ9Im1ou9Z1LH3uOOQBzyP8J3VJ/g8eb5wQ
        GH4hHXhxLdML2sOk/eTApvzaA+hIXLeX1vc/k6RU+UbZ09Du3kVsATkwCMxwkQzzPChy5X
        CqjomECqnwiXFco/Du1djM013ZAV5lY=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-ZI0yOhbSNFaPKBQxJVpKUg-1; Tue, 15 Mar 2022 04:19:44 -0400
X-MC-Unique: ZI0yOhbSNFaPKBQxJVpKUg-1
Received: by mail-pf1-f199.google.com with SMTP id 16-20020a621910000000b004f783aad863so8296625pfz.15
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 01:19:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=3uXmagTXpajgb16CBvtp/WGdSbWtbXyqqh5a7pgAtr8=;
        b=mUDthWHq6yyo2nVq1Y6OBBkG39Vsl7UBV/CTfjUM7UyYSTV9tCy623ZJpW2nMrd/lN
         xZr0nnH+GMHlMETH86ny0O0t5FUj79gRenv9F8/qL2dwnErn5l6lD2YR4uZp+6kRtdlI
         K3wNkzi4i+FOXNVFXl0Lj0mP9l1nm6K0OdDfIWOmEMmyMR4WalXOhXcqtabP6q4D7MH+
         WKj+sBV2XA3FebrlQz7ycBx4QrNdWW5om24JzWOqnkDjzuEikivyEQUN6XH/p/nsJIg1
         X4xygOfUtGTEReJ6zo0+K7demoh6cQGbf3VdbcaCseZDxpKPdgFVKQBA8ulsQ2b1yOoP
         NNgw==
X-Gm-Message-State: AOAM533bQAMgnwdtMgWMLWLg2eAiW0ddNaLcgqzgdvjgunnC5bgwzDkh
        7nI14Led5YFT6fUPAMyTyz4FO1w4mpwO7VQ3MFCEYmbEUVtQ73atSIqWZnaXVbzlSx/T2FZNbNs
        D8jkxrPr2TWibtMT/PIYGAg==
X-Received: by 2002:a17:902:8b87:b0:14d:7920:e54a with SMTP id ay7-20020a1709028b8700b0014d7920e54amr26714353plb.140.1647332383768;
        Tue, 15 Mar 2022 01:19:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcZVy2vN+4L06UglQsYXv6Y56X5wbu6QcFU6qiL6fvqxCvk2p4b/shZhWwAWrkWfQo0pSpXw==
X-Received: by 2002:a17:902:8b87:b0:14d:7920:e54a with SMTP id ay7-20020a1709028b8700b0014d7920e54amr26714334plb.140.1647332383539;
        Tue, 15 Mar 2022 01:19:43 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z72-20020a627e4b000000b004f70cbcb06esm22275374pfc.49.2022.03.15.01.19.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 01:19:42 -0700 (PDT)
Subject: Re: [PATCH] ceph: get snap_rwsem read lock in handle_cap_export for
 ceph_add_cap
To:     Niels Dossche <dossche.niels@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
References: <20220314200717.52033-1-dossche.niels@gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8d67b726-776a-c9d1-281b-481ff98b6fa3@redhat.com>
Date:   Tue, 15 Mar 2022 16:19:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220314200717.52033-1-dossche.niels@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/15/22 4:07 AM, Niels Dossche wrote:
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
>   fs/ceph/caps.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index b472cd066d1c..0dd60db285b1 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3903,8 +3903,10 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
>   		/* add placeholder for the export tagert */
>   		int flag = (cap == ci->i_auth_cap) ? CEPH_CAP_FLAG_AUTH : 0;
>   		tcap = new_cap;
> +		down_read(&mdsc->snap_rwsem);
>   		ceph_add_cap(inode, tsession, t_cap_id, issued, 0,
>   			     t_seq - 1, t_mseq, (u64)-1, flag, &new_cap);
> +		up_read(&mdsc->snap_rwsem);
>   
>   		if (!list_empty(&ci->i_cap_flush_list) &&
>   		    ci->i_auth_cap == tcap) {

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>

