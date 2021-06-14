Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFD73A5FFD
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Jun 2021 12:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhFNK0C (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Jun 2021 06:26:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232819AbhFNK0B (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 06:26:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623666238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QNRJw6fpIHSzIkfmG4HVcWoOuXXwJCtOUgGXzJ7/bwU=;
        b=eijPq+1yipN3WjjFuhRPMvuQi0iDTy25WNRdAjX/JmOStInCc+7udvu1cBtXf/74iX3Jsi
        3St3oNWeYN9y/P/r1TRBN4sAlp1EXbyT9XEmrARrWEngd9Wz3QHWbe25t8VsKmmRBCgzp1
        JqYA+Ob+Qep9p2Ou3FNXF3BrHl/yB4Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-jpaKcnQoP_2qD8T7aIKbbg-1; Mon, 14 Jun 2021 06:23:55 -0400
X-MC-Unique: jpaKcnQoP_2qD8T7aIKbbg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83912193411F;
        Mon, 14 Jun 2021 10:23:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-118-65.rdu2.redhat.com [10.10.118.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87E295D9DD;
        Mon, 14 Jun 2021 10:23:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20210613233345.113565-1-jlayton@kernel.org>
References: <20210613233345.113565-1-jlayton@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     dhowells@redhat.com, linux-cachefs@redhat.com, idryomov@gmail.com,
        willy@infradead.org, pfmeec@rit.edu, ceph-devel@vger.kernel.org,
        Andrew W Elble <aweits@rit.edu>
Subject: Re: [PATCH] netfs: fix test for whether we can skip read when writing beyond EOF
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <340983.1623666185.1@warthog.procyon.org.uk>
Date:   Mon, 14 Jun 2021 11:23:05 +0100
Message-ID: <340984.1623666185@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> wrote:

> +	/* full page write */
> +	if (offset == 0 && len >= thp_size(page))
> +		goto zero_out;

Why not just return?

David Howells <dhowells@redhat.com> wrote:

> Why not:
> 
> 	if (page_offset(page) >= i_size)

And if I switch to this, then:

	/* Zero-length file */
	if (i_size == 0)
		goto zero_out;

this is redundant.

David

