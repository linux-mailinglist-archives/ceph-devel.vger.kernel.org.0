Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EA62694F2
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Sep 2020 20:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgINSfA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Sep 2020 14:35:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbgINSe4 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 14 Sep 2020 14:34:56 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D6B520731;
        Mon, 14 Sep 2020 18:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600108495;
        bh=g4RfMmEoyzllIRIuXhxmM46tNnH/mwa5+jY5JyL/UXo=;
        h=From:To:Cc:Subject:Date:From;
        b=vnyxUh5npObegc+R+GsV+cXtCid+P1GYz7vafgJUgOtVy4U4GeDu9kDh3lMLnw/k0
         P+wdd3ohRoTj92zZSDDEtZIPkZoO94BmrRmNjsEoQusfaRIqniy3taZOLJ71pK5w6c
         YRYWNe8copgHHooWVUsyhcWlMSP99U/ao9Q7uwLc=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     willy@infradead.org
Subject: [PATCH] ceph: have ceph_writepages_start call pagevec_lookup_range_tag
Date:   Mon, 14 Sep 2020 14:34:52 -0400
Message-Id: <20200914183452.378189-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently it calls pagevec_lookup_range_nr_tag(), but Willy pointed out
that that is probably inefficient, as we might end up having to search
several times if we get down to looking for one more page to fill a
write.

"I think ceph is misusing pagevec_lookup_range_nr_tag().  Let's suppose
 you get a range which is AAAAbbbbAAAAbbbbAAAAbbbbbbbb(...)bbbbAAAA and
 you try to fetch max_pages=13.  First loop will get AAAAbbbbAAAAb and
 have 8 locked_pages.  The next call will get bbbAA and now
 locked_pages=10.  Next call gets AAb ... and now you're iterating your
 way through all the 'b' one page at a time until you find that first A."

'A' here refers to pages that are eligible for writeback and 'b'
represents ones that aren't (for whatever reason).

Ceph is also the only caller of pagevec_lookup_range_nr_tag(), so
changing this code to use pagevec_lookup_range_tag() should allow us to
eliminate that call as well. That may mean that we sometimes find more
pages than are needed, but the extra references will just get put at the
end regardless.

Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

I'm still testing this, but it looks good so far. If it's OK, we'll get
this in for v5.10, and then I'll send a patch to remove
pagevec_lookup_range_nr_tag.

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6ea761c84494..b03dbaa9d345 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -962,9 +962,8 @@ static int ceph_writepages_start(struct address_space *mapping,
 		max_pages = wsize >> PAGE_SHIFT;
 
 get_more_pages:
-		pvec_pages = pagevec_lookup_range_nr_tag(&pvec, mapping, &index,
-						end, PAGECACHE_TAG_DIRTY,
-						max_pages - locked_pages);
+		pvec_pages = pagevec_lookup_range_tag(&pvec, mapping, &index,
+						end, PAGECACHE_TAG_DIRTY);
 		dout("pagevec_lookup_range_tag got %d\n", pvec_pages);
 		if (!pvec_pages && !locked_pages)
 			break;
-- 
2.26.2

