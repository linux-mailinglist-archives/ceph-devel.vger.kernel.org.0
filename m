Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210804366AC
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Oct 2021 17:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbhJUPqP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Oct 2021 11:46:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231659AbhJUPqO (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 21 Oct 2021 11:46:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97A6C611CE;
        Thu, 21 Oct 2021 15:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634831038;
        bh=Mfzu0VeAcXV8EZu1YMCp1rSP47OywZ890ZlNdLAJD68=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bkTNF90TOvPQ/PHBRLeztWLd0SErJ1bPNnEVsfif7/tlOSw1rrRV5tETTDIljROVA
         ILezFzTnVeupMBTFZ90w/EBbYJP8n6oC8qtYuSErOMx0g5BjGGF8ZRmdxkgQaS3XTd
         Ls76sbMEMxeoyPOgCQ4diiDyrw4NHkfx0acskDPMCJ9vJsOKOl3QhAQOiZ4vtAszXY
         mcqjTpNJHpvGCDpvZVEaCbuRV6gvCSkhy2EOogS79Fr1KQ1wP+NDkzullfWzMCEIq9
         385Qf+mhgJumHqtKZHlyA0LcBZxBjeTpnhp8II+AiNIdOVK6A87Maose9dC9OUZVJS
         364Ifch4amotw==
Message-ID: <99209198dd9d8634245f153a90e4091851635a16.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: add remote object copy counter to fs client
From:   Jeff Layton <jlayton@kernel.org>
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Date:   Thu, 21 Oct 2021 11:43:55 -0400
In-Reply-To: <CA+2bHPbqeH_rmmxcnQ9gq0K8gqtE4q69a8cFnherSJCxSwXV5Q@mail.gmail.com>
References: <20211020143708.14728-1-lhenriques@suse.de>
         <34e379f9dec1cbdf09fffd8207f6ef7f4e1a6841.camel@kernel.org>
         <CA+2bHPbqeH_rmmxcnQ9gq0K8gqtE4q69a8cFnherSJCxSwXV5Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-10-21 at 09:52 -0400, Patrick Donnelly wrote:
> On Wed, Oct 20, 2021 at 12:27 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > On Wed, 2021-10-20 at 15:37 +0100, Luís Henriques wrote:
> > > This counter will keep track of the number of remote object copies done on
> > > copy_file_range syscalls.  This counter will be filesystem per-client, and
> > > can be accessed from the client debugfs directory.
> > > 
> > > Cc: Patrick Donnelly <pdonnell@redhat.com>
> > > Signed-off-by: Luís Henriques <lhenriques@suse.de>
> > > ---
> > > This is an RFC to reply to Patrick's request in [0].  Note that I'm not
> > > 100% sure about the usefulness of this patch, or if this is the best way
> > > to provide the functionality Patrick requested.  Anyway, this is just to
> > > get some feedback, hence the RFC.
> > > 
> > > Cheers,
> > > --
> > > Luís
> > > 
> > > [0] https://github.com/ceph/ceph/pull/42720
> > > 
> > 
> > I think this would be better integrated into the stats infrastructure.
> > 
> > Maybe you could add a new set of "copy" stats to struct
> > ceph_client_metric that tracks the total copy operations done, their
> > size and latency (similar to read and write ops)?
> 
> I think it's a good idea to integrate this into "stats" but I think a
> local debugfs file for some counters is still useful. The "stats"
> module is immature at this time and I'd rather not build any qa tests
> (yet) that rely on it.
> 
> Can we generalize this patch-set to a file named "op_counters" or
> similar and additionally add other OSD ops performed by the kclient?
> 


Tracking this sort of thing is the main purpose of the stats code. I'm
really not keen on adding a whole separate set of files for reporting
this. 

What's the specific problem with relying on the data in debugfs
"metrics" file?


-- 
Jeff Layton <jlayton@kernel.org>

