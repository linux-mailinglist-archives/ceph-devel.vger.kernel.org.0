Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 211D7F51B4
	for <lists+ceph-devel@lfdr.de>; Fri,  8 Nov 2019 17:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfKHQ5b (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 Nov 2019 11:57:31 -0500
Received: from tragedy.dreamhost.com ([66.33.205.236]:42360 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfKHQ5b (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 8 Nov 2019 11:57:31 -0500
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id D5C5715F8AC;
        Fri,  8 Nov 2019 08:57:29 -0800 (PST)
Date:   Fri, 8 Nov 2019 16:57:27 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Luis Henriques <lhenriques@suse.com>
cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] ceph: safely use 'copy-from' Op on Octopus
 OSDs
In-Reply-To: <20191108164758.GA1760@hermes.olymp>
Message-ID: <alpine.DEB.2.21.1911081656320.10553@piezo.novalocal>
References: <20191108141555.31176-1-lhenriques@suse.com> <CAOi1vP-sVQKvpiPLoZ=9s7Hy=c2eQRocxSs1nPrXAUCbbZUZ-g@mail.gmail.com> <20191108164758.GA1760@hermes.olymp>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedruddvuddgleejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffujgfkfhgfgggtsehttdertddtredvnecuhfhrohhmpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqnecukfhppeduvdejrddtrddtrddunecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtpdhinhgvthepuddvjedrtddrtddruddprhgvthhurhhnqdhprghthhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqedpmhgrihhlfhhrohhmpehsrghgvgesnhgvfigurhgvrghmrdhnvghtpdhnrhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 8 Nov 2019, Luis Henriques wrote:
> On Fri, Nov 08, 2019 at 04:15:35PM +0100, Ilya Dryomov wrote:
> > If the OSD checked for unknown flags, like newer syscalls do, it would
> > be super easy, but it looks like it doesn't.
> > 
> > An obvious solution is to look at require_osd_release in osdmap, but we
> > don't decode that in the kernel because it lives the OSD portion of the
> > osdmap.  We could add that and consider the fact that the client now
> > needs to decode more than just the client portion a design mistake.
> > I'm not sure what can of worms does that open and if copy-from alone is
> > worth it though.  Perhaps that field could be moved to (or a copy of it
> > be replicated in) the client portion of the osdmap starting with
> > octopus?  We seem to be running into it on the client side more and
> > more...
> 
> I can't say I'm thrilled with the idea of going back to hack into the
> OSDs code again, I was hoping to be able to handle this with the
> information we already have on the connection peer_features field.  It
> took me *months* to have the OSD fix merged in so I'm not really
> convinced a change to the osdmap would make it into Octopus :-)
> 
> (But I'll have a look at this and see if I can understand what moving or
> replicating the field in the osdmap would really entail.)

Adding a copy of require_osd_release in the client portion of the map is 
an easy thing to do (and probably where it should have gone in the first 
place!).  Let's do that!

sage
