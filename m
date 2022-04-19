Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573F9506D5F
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Apr 2022 15:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344940AbiDSNY6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Apr 2022 09:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbiDSNY5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Apr 2022 09:24:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C277713CCF
        for <ceph-devel@vger.kernel.org>; Tue, 19 Apr 2022 06:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650374530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/vWnscJn2rlc9lBzVIRZvOmgimaS68XSLiYlSGOcYy0=;
        b=RDXeT3anAduY+6OKonuKQE5aw6ftqsoKIk0iLH/kYDZ20N7qR3SrZM+KL95SmYeVM0FdII
        zGRd1fzcYCd85yjqUTGPDGDEXGKhnjOUjWBCwH1LWaYE/COA7V/ziqP0r+vqAErW+5yM4w
        MIMGrhZ1v2/SyylKHFcO0nRFxpWHMbs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-0y_ADZzONOiUtinQmQkV7w-1; Tue, 19 Apr 2022 09:22:09 -0400
X-MC-Unique: 0y_ADZzONOiUtinQmQkV7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22D903C13A07;
        Tue, 19 Apr 2022 13:22:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50843112C06E;
        Tue, 19 Apr 2022 13:22:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <54d0b7f67cc1c8302fc2d4ff6109d0090f6a4220.camel@kernel.org>
References: <54d0b7f67cc1c8302fc2d4ff6109d0090f6a4220.camel@kernel.org> <20220411093405.301667-1-xiubli@redhat.com> <c013aafd233d4ec303238425b11f6c96c8a3b7a7.camel@kernel.org> <b38b37bc-faa7-cbae-ce3a-f10c0818a293@redhat.com> <d57a0fd93e18d065a0deb3c82dc43595e67b2326.camel@kernel.org> <d81b7216-2694-4ec2-17b4-0869f485f757@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     dhowells@redhat.com, Xiubo Li <xiubli@redhat.com>,
        idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Subject: Re: [RFC resend PATCH] ceph: fix statx AT_STATX_DONT_SYNC vs AT_STATX_FORCE_SYNC check
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <458687.1650374525.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 19 Apr 2022 14:22:05 +0100
Message-ID: <458688.1650374525@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> wrote:

>     if ((flags & AT_STATX_SYNC_TYPE) =3D=3D (AT_STATX_DONT_SYNC|AT_STATX=
_FORCE_SYNC))

You can't do that.  DONT_SYNC and FORCE_SYNC aren't bit flags - they're an
enumeration in a bit field.  There's a reserved value at 0x6000 that doesn=
't
have a symbol assigned.

David

