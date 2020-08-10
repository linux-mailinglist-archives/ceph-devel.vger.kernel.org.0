Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09AB424083F
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Aug 2020 17:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgHJPRO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Aug 2020 11:17:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41070 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725873AbgHJPRN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 10 Aug 2020 11:17:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597072631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tzFIJ6QrKu4yoI3w842fEVOcfFitxszWJPwA8w1tzak=;
        b=gsEV3+a5sDDGnwKPCs6FmFDggH72VBxwiPTk33brn0K1AakWALCRBnHdNXqjtMgfDyR6Hh
        8PKk1j0gFBI0+ALjumgmmCbD6XTmy1oRA3v1gsWBHDxH151CpgtSN20/EKHXbYba2yC+c9
        3waPk0gUCK4FoWv8mN9r8zhGkOKv2iY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-F6eKrt3VN1Knd3NgOWyHPg-1; Mon, 10 Aug 2020 11:17:09 -0400
X-MC-Unique: F6eKrt3VN1Knd3NgOWyHPg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D0288005B0;
        Mon, 10 Aug 2020 15:17:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-69.rdu2.redhat.com [10.10.113.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB1795D9CD;
        Mon, 10 Aug 2020 15:16:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <1851200.1596472222@warthog.procyon.org.uk>
References: <1851200.1596472222@warthog.procyon.org.uk> <447452.1596109876@warthog.procyon.org.uk>
To:     torvalds@linux-foundation.org
Cc:     dhowells@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Jeff Layton <jlayton@redhat.com>,
        Dave Wysochanski <dwysocha@redhat.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        ceph-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fscache rewrite -- please drop for now
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <667819.1597072619.1@warthog.procyon.org.uk>
Date:   Mon, 10 Aug 2020 16:16:59 +0100
Message-ID: <667820.1597072619@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

Can you drop the fscache rewrite pull for now.  We've seem an issue in NFS
integration and need to rework the read helper a bit.  I made an assumption
that fscache will always be able to request that the netfs perform a read of a
certain minimum size - but with NFS you can break that by setting rsize too
small.

We need to make the read helper able to make multiple netfs reads.  This can
help ceph too.

Thanks,
David

