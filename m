Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCCB44CAF6
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Nov 2021 22:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhKJVK4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 Nov 2021 16:10:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233219AbhKJVKz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 10 Nov 2021 16:10:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636578486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=RL/EowzczUDf0c++gAzZ8s42VZcgm4/UY4al6ue8qeQ=;
        b=cOgaKjfeyq31Q9ixjam8cuxrIWrFzfUovW5MNKfqHosBW0Q2yG+jj3BUfpiXHQAUhJY9lk
        OUpUlF79TTlEwqIjnQkkiiAbgbyOLIIl94j8Y5HgYYifhbLYzOVhF3WtZD8oVUf/MlZQoH
        MojBkdA5qX95j0tkfD1rR1kti50XG7E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-E0UUaYW9NRKIqZJHYJZzTw-1; Wed, 10 Nov 2021 16:08:03 -0500
X-MC-Unique: E0UUaYW9NRKIqZJHYJZzTw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FE9418A0728;
        Wed, 10 Nov 2021 21:08:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.37.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3DB360240;
        Wed, 10 Nov 2021 21:07:56 +0000 (UTC)
Subject: [PATCH v5 0/4] netfs, 9p, afs, ceph: Support folios,
 at least partially
From:   David Howells <dhowells@redhat.com>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-afs@lists.infradead.org, Jeff Layton <jlayton@kernel.org>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-cachefs@redhat.com,
        Dominique Martinet <asmadeus@codewreck.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        kafs-testing@auristor.com, v9fs-developer@lists.sourceforge.net,
        dhowells@redhat.com, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
        v9fs-developer@lists.sourceforge.net,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 10 Nov 2021 21:07:56 +0000
Message-ID: <163657847613.834781.7923681076643317435.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


Here's a set of patches to convert netfs, 9p and afs to use folios and to
provide sufficient conversion for ceph that it can continue to use the
netfs library.  Jeff Layton is working on fully converting ceph.

This has been rebased on to the 9p merge in Linus's tree[5] so that it has
access to both the 9p conversion to fscache and folios.

Changes
=======
ver #5:
 - Got rid of the folio_endio bits again as Willy changed his mind and
   would rather I inlined the code directly instead.

ver #4:
 - Detached and sent the afs symlink split patch separately.
 - Handed the 9p netfslibisation patch off to Dominique Martinet.
 - Added a patch to foliate page_endio().
 - Fixed a bug in afs_redirty_page() whereby it didn't set the next page
   index in the loop and returned too early.
 - Simplified a check in v9fs_vfs_write_folio_locked()[4].
 - Undid a change to afs_symlink_readpage()[4].
 - Used offset_in_folio() in afs_write_end()[4].
 - Rebased on 9p-folio merge upstream[5].

ver #3:
 - Rebased on upstream as folios have been pulled.
 - Imported a patch to convert 9p to netfslib from my
   fscache-remove-old-api branch[3].
 - Foliated netfslib.

ver #2:
 - Reorder the patches to put both non-folio afs patches to the front.
 - Use page_offset() rather than manual calculation[1].
 - Fix folio_inode() to directly access the inode[2].

David

Link: https://lore.kernel.org/r/YST/0e92OdSH0zjg@casper.infradead.org/ [1]
Link: https://lore.kernel.org/r/YST8OcVNy02Rivbm@casper.infradead.org/ [2]
Link: https://lore.kernel.org/r/163551653404.1877519.12363794970541005441.stgit@warthog.procyon.org.uk/ [3]
Link: https://lore.kernel.org/r/YYKa3bfQZxK5/wDN@casper.infradead.org/ [4]
Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f89ce84bc33330607a782e47a8b19406ed109b15 [5]
Link: https://lore.kernel.org/r/2408234.1628687271@warthog.procyon.org.uk/ # v0
Link: https://lore.kernel.org/r/162981147473.1901565.1455657509200944265.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/163005740700.2472992.12365214290752300378.stgit@warthog.procyon.org.uk/ # v2
Link: https://lore.kernel.org/r/163584174921.4023316.8927114426959755223.stgit@warthog.procyon.org.uk>/ # v3
Link: https://lore.kernel.org/r/163649323416.309189.4637503793406396694.stgit@warthog.procyon.org.uk/ # v4
---
David Howells (4):
      folio: Add a function to change the private data attached to a folio
      folio: Add a function to get the host inode for a folio
      netfs, 9p, afs, ceph: Use folios
      afs: Use folios in directory handling


 fs/9p/vfs_addr.c           |  83 +++++----
 fs/9p/vfs_file.c           |  20 +--
 fs/afs/dir.c               | 229 ++++++++++--------------
 fs/afs/dir_edit.c          | 154 ++++++++--------
 fs/afs/file.c              |  70 ++++----
 fs/afs/internal.h          |  46 ++---
 fs/afs/write.c             | 347 ++++++++++++++++++-------------------
 fs/ceph/addr.c             |  80 +++++----
 fs/netfs/read_helper.c     | 165 +++++++++---------
 include/linux/netfs.h      |  12 +-
 include/linux/pagemap.h    |  14 ++
 include/trace/events/afs.h |  21 +--
 mm/page-writeback.c        |   2 +-
 13 files changed, 617 insertions(+), 626 deletions(-)



Tested-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Dominique Martinet <asmadeus@codewreck.org>
Tested-by: kafs-testing@auristor.com

