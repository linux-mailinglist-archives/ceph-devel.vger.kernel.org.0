Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCF23A6602
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Jun 2021 13:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbhFNLuv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Jun 2021 07:50:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55477 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233212AbhFNLrp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 07:47:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623671142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6NA6ypYR/eYTI4PSfr11OgVNNF0XskP8mfgyTkHWkfM=;
        b=MU7Z/hCZmyzO8K9cOhBNzEqVzO3KJ6qEuMe6WBWBBwRvfgzqvKMlhDC8M8mYHvKztGXdah
        QVVz15K8HLoDvsQYvk2HaZfAG4cwZxsAo/VTyIfSpLlAtkPnMmmzO1J3fzsTyaeGqfswLV
        KxdFoDrdEbdyzcndBKxXk6cf01zv/1M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-QsV0dWywMcmdiDwYI6wGRw-1; Mon, 14 Jun 2021 07:45:41 -0400
X-MC-Unique: QsV0dWywMcmdiDwYI6wGRw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C39728049D9;
        Mon, 14 Jun 2021 11:45:39 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-118-65.rdu2.redhat.com [10.10.118.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D35C19C45;
        Mon, 14 Jun 2021 11:45:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <4d1c9cf43d336b32dceabd2a28e9f68937c2e7a9.camel@kernel.org>
References: <4d1c9cf43d336b32dceabd2a28e9f68937c2e7a9.camel@kernel.org> <20210613233345.113565-1-jlayton@kernel.org> <338981.1623665093@warthog.procyon.org.uk>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     dhowells@redhat.com, linux-cachefs@redhat.com, idryomov@gmail.com,
        willy@infradead.org, pfmeec@rit.edu, ceph-devel@vger.kernel.org,
        Andrew W Elble <aweits@rit.edu>
Subject: Re: [PATCH] netfs: fix test for whether we can skip read when writing beyond EOF
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <348580.1623671134.1@warthog.procyon.org.uk>
Date:   Mon, 14 Jun 2021 12:45:34 +0100
Message-ID: <348581.1623671134@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> wrote:

> > Why not:
> > 
> > 	if (page_offset(page) >= i_size)
> > 
> 
> That doesn't handle THP's correctly. It's just a PAGE_SIZE shift.

I asked Willy about that one and he said it will.  Now, granted, the code
doesn't seem to do that, but possibly he has a patch for it?

David

