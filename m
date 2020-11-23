Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901462C10DB
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Nov 2020 17:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390100AbgKWQji (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Nov 2020 11:39:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390097AbgKWQjh (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 11:39:37 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B68520717;
        Mon, 23 Nov 2020 16:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606149576;
        bh=dvrw3U7i0FbsZUcrV9YFEctfe0OW3C+miUY78sQDrdo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EmtS288urWQElUEmlK8kytUUM4cx60hzZjQkJJbIc2PhdQvOvXUhGGzv1jvTJCBIP
         mvMkc5ipIRcHpWkGvhQBFpb7J9Z919RjsJ63FL8Uct9gSpMfMYQvrlg9Qnfn4YUFJb
         OdWKiFD3VJX6CSbZwEBTySABHIjLudBw/BNa6BkQ=
Message-ID: <9b69966cfecc66fe1d8ff02909050ceb2f7b1152.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: add a new test for cross quota realms renames
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Eryu Guan <guan@eryu.me>, fstests@vger.kernel.org,
        ceph-devel@vger.kernel.org
Date:   Mon, 23 Nov 2020 11:39:35 -0500
In-Reply-To: <87eekkrqhh.fsf@suse.de>
References: <87sg90s8el.fsf@suse.de>
         <20201123103439.27908-1-lhenriques@suse.de>
         <adf5a0056e11fe2575915a4d416b2f65cba02ded.camel@kernel.org>
         <87im9wrv5p.fsf@suse.de>
         <592a539905ba13d26bd12d8fa74cc4942b68c8ea.camel@kernel.org>
         <87eekkrqhh.fsf@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-11-23 at 16:24 +0000, Luis Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
> 
> > On Mon, 2020-11-23 at 14:43 +0000, Luis Henriques wrote:
> > > Jeff Layton <jlayton@kernel.org> writes:
> > > 
> > > > On Mon, 2020-11-23 at 10:34 +0000, Luis Henriques wrote:
> > > > > For the moment cross quota realms renames has been disabled in CephFS
> > > > > after a bug has been found while renaming files created and truncated.
> > > > > This allowed clients to easily circumvent quotas.
> > > > > 
> > > > > Link: https://tracker.ceph.com/issues/48203
> > > > > Signed-off-by: Luis Henriques <lhenriques@suse.de>
> > > > > ---
> > > > > v2: implemented Eryu review comments:
> > > > > - Added _require_test_program "rename"
> > > > > - Use _fail instead of _fatal
> > > > > 
> > > > >  tests/ceph/004     | 95 ++++++++++++++++++++++++++++++++++++++++++++++
> > > > >  tests/ceph/004.out |  2 +
> > > > >  tests/ceph/group   |  1 +
> > > > >  3 files changed, 98 insertions(+)
> > > > >  create mode 100755 tests/ceph/004
> > > > >  create mode 100644 tests/ceph/004.out
> > > > > 
> > > > > diff --git a/tests/ceph/004 b/tests/ceph/004
> > > > > new file mode 100755
> > > > > index 000000000000..53094d8dfadc
> > > > > --- /dev/null
> > > > > +++ b/tests/ceph/004
> > > > > @@ -0,0 +1,95 @@
> > > > > +#! /bin/bash
> > > > > +# SPDX-License-Identifier: GPL-2.0
> > > > > +# Copyright (c) 2020 SUSE Linux Products GmbH. All Rights Reserved.
> > > > > +#
> > > > > +# FS QA Test 004
> > > > > +#
> > > > > +# Tests a bug fix found in cephfs quotas handling.  Here's a simplified testcase
> > > > > +# that *should* fail:
> > > > > +#
> > > > > +#    mkdir files limit
> > > > > +#    truncate files/file -s 10G
> > > > > +#    setfattr limit -n ceph.quota.max_bytes -v 1000000
> > > > > +#    mv files limit/
> > > > > +#
> > > > > +# Because we're creating a new file and truncating it, we have Fx caps and thus
> > > > > +# the truncate operation will be cached.  This prevents the MDSs from updating
> > > > > +# the quota realms and thus the client will allow the above rename(2) to happen.
> > > > > +#
> > > > 
> > > > Note that it can be difficult to predict which caps you get from the
> > > > MDS. It's not _required_ to pass out anything like Fx if it doesn't want
> > > > to, but in general, it does if it can.
> > > > 
> > > > It's not a blocker for merging this test, but I wonder if we ought to
> > > > come up with some way to ensure that the client was given the caps we
> > > > expect when testing stuff like this.
> > > > 
> > > > Maybe we ought to consider adding a new ceph.caps vxattr that shows the
> > > > caps we hold for a particular file? Then we could consult that when
> > > > doing a test like this to make sure we got what we expected.
> > > 
> > > Sure, I can hack a patch for doing that and send it out for review.
> > > That's actually trivial, I believe.
> > > 
> > > This test assumes the caps for the truncated file will be 'Fsxcrwb' but I
> > > didn't confirm with the MDS which conditions are actually required for
> > > this to happen.  Also, I guess that if the test is executed with several
> > > clients, these caps may change pretty quickly (and maybe even with a
> > > single very slow client with a very short caps timeout).
> > > 
> > > Obviously, ensuring the client has the caps we expect at the time we do
> > > the actual rename is racy and they can change in the meantime.  Is it
> > > worth the trouble?
> > 
> > 
> > I think it's useful. Cap/mds lock handling is an area where we have
> > really poor visibility in cephfs.
> > 
> > a/ It's not always 100% clear what metadata is under which cap.
> > Sometimes it's really weird. For example, you need Fs to get the link
> > count on a directory -- Ls has no meaning there, which is not intuitive
> > at all.
> > 
> > b/ Subtle changes in the MDS or client can affect what caps are granted
> > or revoked in a given situation. 
> > 
> > Having better visibility into the caps held by the client is potentially
> > very useful for troubleshooting _why_ certain tests might fail, and may
> > also help us catch subtle changes that prevent problems in the future.
> 
> Sure, I completely agree with this.  My question was more about adding an
> extra check to the test.  Basically, the new test will be something like:
> 
>  (0. ensure 'getfattr -n ceph.caps' works; skip test if it doesn't)
>   1. truncate file
>   2. check that file caps includes Fsxcrwb
>   3. do the rename
> 

Sounds reasonable. You may not even need to test for that whole cap set
either. For this test, you probably just need to ensure that it got Fs.
I'd be a little leery about failing the test if we got a different set
of caps that still happened to contain Fs.

-- 
Jeff Layton <jlayton@kernel.org>

