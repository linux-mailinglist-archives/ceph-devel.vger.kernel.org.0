Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF4161944C5
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Mar 2020 17:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgCZQ6g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 Mar 2020 12:58:36 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:57587 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725994AbgCZQ6g (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 26 Mar 2020 12:58:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585241914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vknIlv9hDd1Pl6KoDnhlDxfTgvHETkkUyYpHnMEQzCM=;
        b=D3sAojq0kYTVJW5/z6rZC8eYjleJn4e+G1+6wlggMmwIxoVc8R0w++LaTU7xwwFgJcZVbl
        Qh9bOULXkH3FyoErj7VCbp24amAcHxH7rRbI37Jn32h7FGwfFoCQ32moD3DTM9arVxIM21
        saXhJmT702RgalLcWdjKTsqYNE08PsU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-z9LjZdO7Neyr-J8rhjqAbg-1; Thu, 26 Mar 2020 12:58:32 -0400
X-MC-Unique: z9LjZdO7Neyr-J8rhjqAbg-1
Received: by mail-qk1-f197.google.com with SMTP id r64so4742419qkc.17
        for <ceph-devel@vger.kernel.org>; Thu, 26 Mar 2020 09:58:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=vknIlv9hDd1Pl6KoDnhlDxfTgvHETkkUyYpHnMEQzCM=;
        b=VfrwI2sKSC0Y49xuntN18wnCogANlj2lpo67dHRYbCTb2CMOPjMSCOHLvw4H2qTdqj
         v3YNgMID2SM2avzM73WQ+zXfOWfdIYVSdkGNifL9wMcvkowqE0P7i0qAKZFDMvvQVP5V
         klL+R7q/2CFZrr3afILXOMpRA3xXZRMTrhZazy5DVQp4BNjQ4P2jaZ4a/0Fu5vEm1T41
         oswE010ld4ZopTYofNE36BFTcVtr/ryuokBzjfrE020lPQzu8BVnPWUpiADaRFpT9Bn7
         BGqSmeTAfkjyZmNY+CiDHB0eM5ZEz7zel+mShH73jNswVqMNg0d56pW2vpW0Hq3nTjas
         Omlg==
X-Gm-Message-State: ANhLgQ3IJRRqYGi5C06G+lUBeokso1BsElSo0Y0jCHCuX1vGzxqwCGIv
        ao9p8jg4hR4YaJNgXovRKfgUFCuymkHsT9ifJ3atDF08/JByCb/PdjNzGvjkr+WMnhGTvaIk3fU
        OI7hFNr7psJazuK9Qc6KxhQ==
X-Received: by 2002:a37:a755:: with SMTP id q82mr9446532qke.390.1585241911542;
        Thu, 26 Mar 2020 09:58:31 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vv2azWG1ISNsa1K/CEzTYNxS3gIY9RpILqc1k76XPNyBxfNRlpBvTMFkf1x9pnSmQElme+Hnw==
X-Received: by 2002:a37:a755:: with SMTP id q82mr9446430qke.390.1585241910507;
        Thu, 26 Mar 2020 09:58:30 -0700 (PDT)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id q24sm1933789qtk.45.2020.03.26.09.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 09:58:30 -0700 (PDT)
Message-ID: <d6e7fca9b7276f36f828182faceea92bdc254fb1.camel@redhat.com>
Subject: reducing s_mutex coverage in kcephfs client
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Sage Weil <sage@redhat.com>
Date:   Thu, 26 Mar 2020 12:58:28 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I had mentioned this in standup this morning, but it's a bit of a
complex topic and Zheng asked me to send email instead. I'm also cc'ing
ceph-devel for posterity...

The locking in the cap handling code is extremely hairy, with many
places where we need to take sleeping locks while we're in atomic
context (under spinlock, mostly). A lot of the problem is due to the
need to take the session->s_mutex.

For instance, there's this in ceph_check_caps:

a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 1999)              if (session && session != cap->session) {
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2000)                      dout("oops, wrong session %p mutex\n", session);
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2001)                      mutex_unlock(&session->s_mutex);
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2002)                      session = NULL;
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2003)              }
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2004)              if (!session) {
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2005)                      session = cap->session;
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2006)                      if (mutex_trylock(&session->s_mutex) == 0) {
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2007)                              dout("inverting session/ino locks on %p\n",
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2008)                                   session);
be655596b3de5 (Sage Weil           2011-11-30 09:47:09 -0800 2009)                              spin_unlock(&ci->i_ceph_lock);
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2010)                              if (took_snap_rwsem) {
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2011)                                      up_read(&mdsc->snap_rwsem);
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2012)                                      took_snap_rwsem = 0;
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2013)                              }
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2014)                              mutex_lock(&session->s_mutex);
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2015)                              goto retry;
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2016)                      }
a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2017)              }

At this point, we're walking the inode's caps rbtree, while holding the
inode->i_ceph_lock. We're eventually going to need to send a cap message
to the MDS for this cap, but that requires the cap->session->s_mutex. We
try to take it without blocking first, but if that fails, we have to
unwind all of the locking and start over. Gross. That also makes the
handling of snap_rwsem much more complex than it really should be too.

It does this, despite the fact that the cap message doesn't actually
need much from the session (just the session->s_con, mostly). Most of
the info in the message comes from the inode and cap objects.

My question is: What is the s_mutex guaranteeing at this point?

More to the point, is it strictly required that we hold that mutex as we
marshal up the outgoing request? It would be much cleaner to be able to
just drop the spinlock after getting the ceph_msg_args ready to send,
then take the session mutex and send the request.

The state of the MDS session is not checked in this codepath before the
send, so it doesn't seem like ordering vs. session state messages is
very important. This _is_ ordered vs. regular MDS requests, but a
per-session mutex seems like a very heavyweight way to do that.

If we're concerned about reordering cap messages that involve the same
inode, then there are other ways to ensure that ordering that don't
require a coarse-grained mutex.

It's just not clear to me what data this mutex is protecting in this
case.

Any hints would be welcome!
-- 
Jeff Layton <jlayton@redhat.com>

