Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEEE373FC2C
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Jun 2023 14:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjF0MwI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jun 2023 08:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjF0MwG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 27 Jun 2023 08:52:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BADA270C
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 05:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687870278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1VBXBjZTvnK2Wk6THBLyuE1SAvZbYMw379uCbCug7dM=;
        b=TpPr5lGidziCB/nNmaF5zJz+E0XYt9kq6fzvJMWkwWV5db+gqGf53BR1b8MR9BoFleRvTv
        aIGFoRM9Waq2kJVCvp66VIncBNlP47L5UDkh25XqxqcdVeMRgeV7exe3C+UjKmei9/sGVY
        +NXMPiOs1lGDu51E/CUuG10zl7vgqEw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-HjmQ7XnzOKmpJ8pbfY54rQ-1; Tue, 27 Jun 2023 08:51:16 -0400
X-MC-Unique: HjmQ7XnzOKmpJ8pbfY54rQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-635df023844so4004856d6.1
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 05:51:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687870276; x=1690462276;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1VBXBjZTvnK2Wk6THBLyuE1SAvZbYMw379uCbCug7dM=;
        b=Eq7zE1Ed7WzIV04npx4cs6sICZFsUrdGehBElzDoihktttD+uBQF4G/D6QE/2CEoVE
         KVRobg/tajLgnKMHQPoF0R3kVNT9fFw8tGvYwR/dd/i/cxb5T6xFLzTGRBtli1JQqBX0
         qxQpqccmCZvExkm2l/7MMrSkk9CsxlUTZwQG+YZ1TKX3H1u4qi4ndgZx/oaDzMpR5vR1
         JBpRxQbQpkCsQamrVeAwV0FafBVNCdFGR6K64eiHotWAlDhcmTzS6SX8hM8oajyDKpGC
         YoXNfpwZv37Fbxsp4s+cLTlHOLkAZkVq2C2meHp2PjGEKnp8CS08eS8QiPlxGdf7BaMv
         OQeg==
X-Gm-Message-State: AC+VfDzHLKeWCwCm5Vz2K2GzeFcusA0rPwR01YsFxuA1Ja/rOPLAXj11
        CLf/Q27r1IoYd9h4XE0ae7Q9opCCOpX6Hg4PdtLYxmPlYjUGgL/I4I1qBN+m41rWNb7fr31AIsc
        1YqXO+WQV04VLPI65EvZixw==
X-Received: by 2002:ad4:4eec:0:b0:635:ec47:bfa4 with SMTP id dv12-20020ad44eec000000b00635ec47bfa4mr2878240qvb.4.1687870276524;
        Tue, 27 Jun 2023 05:51:16 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4gTWjIfL+wjZmdsUf7JwLTLQZrg6rwPJR/TQXtOCe/Cf6jCLoU+HW/e0eIxubgQP4k7rQzpg==
X-Received: by 2002:ad4:4eec:0:b0:635:ec47:bfa4 with SMTP id dv12-20020ad44eec000000b00635ec47bfa4mr2878221qvb.4.1687870276281;
        Tue, 27 Jun 2023 05:51:16 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-239-6.dyn.eolo.it. [146.241.239.6])
        by smtp.gmail.com with ESMTPSA id mz14-20020a0562142d0e00b006300e92ea02sm4478170qvb.121.2023.06.27.05.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 05:51:15 -0700 (PDT)
Message-ID: <b0a0cb0fac4ebdc23f01d183a9de10731dc90093.camel@redhat.com>
Subject: Re: Is ->sendmsg() allowed to change the msghdr struct it is given?
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Howells <dhowells@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, ceph-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 27 Jun 2023 14:51:12 +0200
In-Reply-To: <20230626142257.6e14a801@kernel.org>
References: <3112097.1687814081@warthog.procyon.org.uk>
         <20230626142257.6e14a801@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2023-06-26 at 14:22 -0700, Jakub Kicinski wrote:
> On Mon, 26 Jun 2023 22:14:41 +0100 David Howells wrote:
> > Do you know if ->sendmsg() might alter the msghdr struct it is passed a=
s an
> > argument? Certainly it can alter msg_iter, but can it also modify,
> > say, msg_flags?
>=20
> I'm not aware of a precedent either way.
> Eric or Paolo would know better than me, tho.

udp_sendmsg() can set the MSG_TRUNC bit in msg->msg_flags, so I guess
that kind of actions are sort of allowed. Still, AFAICS, the kernel
based msghdr is not copied back to the user-space, so such change
should be almost a no-op in practice.

@David: which would be the end goal for such action?

Cheers,

Paolo

