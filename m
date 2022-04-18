Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBF1505B11
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Apr 2022 17:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbiDRPcz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Apr 2022 11:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240705AbiDRPc2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Apr 2022 11:32:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 12A9ABC6
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 07:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650293161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G8DTz7fR66KgxJukIlx2AeIe+OnsRbBT2ni4p7HVTyY=;
        b=SOc1vhbvFPMl2DRnOgWk21CMohpCygmDnPdKiizaD7dKXQzg9MN7neodEO5lGiYD6SpGKh
        ExUDGIswFfd5C3CkPbKhEOKbIyFiNYpnoGzyNfyaNMkHN5t/Ol3VpTIOJukfXHFAWDgwP1
        RuSGexl2GZl2eAm/ppa1uVTsfNP/Ijs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-fWQlpiXoNRi99HSWRFwaWw-1; Mon, 18 Apr 2022 10:45:59 -0400
X-MC-Unique: fWQlpiXoNRi99HSWRFwaWw-1
Received: by mail-wm1-f70.google.com with SMTP id b12-20020a05600c4e0c00b003914432b970so4505679wmq.8
        for <ceph-devel@vger.kernel.org>; Mon, 18 Apr 2022 07:45:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G8DTz7fR66KgxJukIlx2AeIe+OnsRbBT2ni4p7HVTyY=;
        b=ph0qhMBDZYaIkQ/F4X5R7ucvr8R1+HuaIr+vZErbnr9IejpEibvOAHrgTCyBw+NMdF
         uQ7T4IlyyJd4fizLAe57f6kt+mVI4AXq19jbcKrXBngQaYCeEIvBp0IhlP41xWRrUDPL
         rZz2zwXw1tCu4sNwX0eaVnOFVrTP4bLVtQM2XnzWqrf4l4zJAfwCex+1wSOH3ZGLAJPL
         CG34yeXs/2GAc+25DbEyTL95EJ8oTVwK0O7toWX/7yym4JTmoJ6gstlH8MDzHsvYWBgj
         /1ESXMCBgyp96uPZaNvEj912qw2eDYNuKmhVOJSngJkp7FSjxcfRy42fWP5imGI0frO2
         saXw==
X-Gm-Message-State: AOAM533Fzf5PoVEgQZt63cICUIPFHzzWTH74PDi5PpJV7TzR0rKQK8xD
        YyQ1AUjoF9pXzNrLH2Ka8O3fF2U4ik0ZKMC5PNndkCcjoCBvXY2dUZvRVEs/P4LBR3irXfFK8Eg
        Tsos9DtCgWqT/QP3jt5Wu
X-Received: by 2002:adf:8071:0:b0:20a:92b2:ff95 with SMTP id 104-20020adf8071000000b0020a92b2ff95mr5035258wrk.672.1650293158110;
        Mon, 18 Apr 2022 07:45:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLv0uyLh0953RTZZY8wwv6H6Y5+dgQdOPqM+4SFYd4kQUFC+n7z6smfmzTavt9gMJo1emn+A==
X-Received: by 2002:adf:8071:0:b0:20a:92b2:ff95 with SMTP id 104-20020adf8071000000b0020a92b2ff95mr5035249wrk.672.1650293157949;
        Mon, 18 Apr 2022 07:45:57 -0700 (PDT)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id z7-20020a7bc7c7000000b0038eaf85b0absm13145882wmk.20.2022.04.18.07.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 07:45:56 -0700 (PDT)
Date:   Mon, 18 Apr 2022 15:45:54 +0100
From:   Aaron Tomlin <atomlin@redhat.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     jlayton@kernel.org, idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2] ceph: fix possible NULL pointer dereference for
 req->r_session
Message-ID: <20220418144554.i7m6omhtulb2nq22@ava.usersys.com>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
References: <20220418014440.573533-1-xiubli@redhat.com>
 <20220418104318.4fb3jpdgnhje4b5d@ava.usersys.com>
 <53d24ea4-554b-2df3-e4ee-6761f6ae5c8e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53d24ea4-554b-2df3-e4ee-6761f6ae5c8e@redhat.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon 2022-04-18 18:52 +0800, Xiubo Li wrote:
> Hi Aaron,

Hi Xiubo,

> Thanks very much for you testing.

No problem!

> BTW, did you test this by using Livepatch or something else ?

I mostly followed your suggestion here [1] by modifying/or patching the
kernel to increase the race window so that unsafe_request_wait() may more
reliably see a newly registered request with an unprepared session pointer
i.e. 'req->r_session == NULL'.

Indeed, with this patch we simply skip such a request while traversing the
Ceph inode's unsafe directory list in the context of unsafe_request_wait().

[1]: https://tracker.ceph.com/issues/55329

Kind regards,

-- 
Aaron Tomlin

