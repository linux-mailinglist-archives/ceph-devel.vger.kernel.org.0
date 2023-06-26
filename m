Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B620473E2F2
	for <lists+ceph-devel@lfdr.de>; Mon, 26 Jun 2023 17:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjFZPNK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 26 Jun 2023 11:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjFZPNJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 26 Jun 2023 11:13:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F12D3
        for <ceph-devel@vger.kernel.org>; Mon, 26 Jun 2023 08:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687792343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z1slXFtt+G0ex6dm14v502Z751krJvUwrnDBAKAckFY=;
        b=epI0L1cUN0RQ/+IPLdFtkS4Sh74AEIzPGefu7VbZ/59dMpKa19OqYeimNNfoYcYLZRLnlH
        4XrRvSM8qtGPmxSoisMMyYu+3d9ju9lCAWrid1lRryupJaYoUpdTdhlUCPuha8lJMp7rad
        UBY2FJWIOEfQi6uhsigbjxRUZzep7Ag=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-Nl8n0UMiMmuAUl-8QQKKKg-1; Mon, 26 Jun 2023 11:12:19 -0400
X-MC-Unique: Nl8n0UMiMmuAUl-8QQKKKg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80E0985A58A;
        Mon, 26 Jun 2023 15:12:14 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5A7D40C6F5A;
        Mon, 26 Jun 2023 15:12:12 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <CAOi1vP9vjLfk3W+AJFeexC93jqPaPUn2dD_4NrzxwoZTbYfOnw@mail.gmail.com>
References: <CAOi1vP9vjLfk3W+AJFeexC93jqPaPUn2dD_4NrzxwoZTbYfOnw@mail.gmail.com> <20230623225513.2732256-1-dhowells@redhat.com> <20230623225513.2732256-4-dhowells@redhat.com>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     dhowells@redhat.com, netdev@vger.kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH net-next v5 03/16] ceph: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3070679.1687792331.1@warthog.procyon.org.uk>
Date:   Mon, 26 Jun 2023 16:12:11 +0100
Message-ID: <3070680.1687792331@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ilya Dryomov <idryomov@gmail.com> wrote:

> > -       int flags = MSG_DONTWAIT | MSG_NOSIGNAL | more;

Btw, why are you setting MSG_DONTWAIT?  If you're in the middle of
transmitting a message on a TCP socket, surely you can't just switch to
transmitting a different message on the same socket without doing some sort of
reframing?

David

