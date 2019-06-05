Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A8B36523
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 22:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfFEUML (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 16:12:11 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:45893 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbfFEUMK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jun 2019 16:12:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id 8790F15F886;
        Wed,  5 Jun 2019 13:12:09 -0700 (PDT)
Date:   Wed, 5 Jun 2019 20:12:07 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Gregory Farnum <gfarnum@redhat.com>
cc:     ceph-devel <ceph-devel@vger.kernel.org>
Subject: Re: MDS refuses startup if id == admin
In-Reply-To: <CAJ4mKGaanO57aK1avp+N4uRocYh1m8qppVe+oEbiTqv7zZkyKA@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1906052010420.13706@piezo.novalocal>
References: <20190604132003.4z6oxllc2ghcncle@jfsuselaptop> <CAJ4mKGaanO57aK1avp+N4uRocYh1m8qppVe+oEbiTqv7zZkyKA@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-912377711-1559765529=:13706"
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudegvddgudeglecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvufgjkfhffgggtgesmhdtreertderjeenucfhrhhomhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqeenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppeduvdejrddtrddtrddunecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtpdhinhgvthepuddvjedrtddrtddruddprhgvthhurhhnqdhprghthhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqedpmhgrihhlfhhrohhmpehsrghgvgesnhgvfigurhgvrghmrdhnvghtpdhnrhgtphhtthhopegtvghphhdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-912377711-1559765529=:13706
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 5 Jun 2019, Gregory Farnum wrote:
> On Tue, Jun 4, 2019 at 6:22 AM Jan Fajerski <jfajerski@suse.com> wrote:
> >
> > Hi list,
> > I came across some strange MDS behaviour recently where it is not possible to
> > start and MDS on a machine that happens to have the hostname "admin".
> >
> > This turns out to be this code
> > https://github.com/ceph/ceph/blob/master/src/common/entity_name.cc#L128 that is
> > called by ceph-mds here
> > https://github.com/ceph/ceph/blob/master/src/ceph_mds.cc#L116.
> >
> > Together with the respective systemd unit file (passing "--id %i") this prevents
> > starting an MDS on a machine witht he hostname admin.
> >
> > Is this just old code and chance or is there a reason behind this? The MDS is
> > the only daemon doing that, though I did not check for other but similar checks
> > in other daemons.
> 
> There's a pretty funny trail of updates there, but it's still
> basically what we see in the MDS code: it doesn't want to turn on if
> it doesn't have a specified name. "admin" is the default (ie,
> client.admin) and so the checker is incorrectly flagging it as being
> unnamed when the name is derived from a host short name "admin".
> 
> I'm not sure there's a good way to deal with that — we really *don't*
> want somebody's misconfigured cluster to start up a bunch of MDSes
> that all display as "mds.admin"!

I think we probably want to change the behavior so that the default name 
is empty instead of admin, and the MDS refuses to start as 'mds.'.  It 
means wading through some of the common/ and global/ code, which is always 
an adventure, but the same cleanup should apply to all of the non-client 
entity types (osd, mgr, mon, etc) too, so it should be time well spent!

sage
--8323329-912377711-1559765529=:13706--
