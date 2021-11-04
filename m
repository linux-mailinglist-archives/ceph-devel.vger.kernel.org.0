Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D4D44566C
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Nov 2021 16:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhKDPj4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Nov 2021 11:39:56 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33566 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhKDPjy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Nov 2021 11:39:54 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BCE3D212BB;
        Thu,  4 Nov 2021 15:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636040235; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uHXKCb2m4aN3DGGo3TS/BoeovESLndRU28nc5R+Ezi4=;
        b=q74JbwjnA8QAd8JclRaVWkB8KdUJB9SAHd64vcm2cn3kViB0IvoPBuT6usdLrE6kDFZQ48
        gcJJZMecREa3Ov2rF5QuZLBGB6gvNe9VkHbQe65z56xbgYrl6Dgpzwohit6Z1i5d9eUoZW
        fDRqUTksVVVyGBukIPKVE1vB5HvT284=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636040235;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uHXKCb2m4aN3DGGo3TS/BoeovESLndRU28nc5R+Ezi4=;
        b=ZBnnY/Sj6shJlRHAq13K4UblSQPcZWW/v96CVCvg40A/Q1QwU1G862FWhF5+GUOroeMJX0
        T21cXxBLmFDAy7CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5947C13BD4;
        Thu,  4 Nov 2021 15:37:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 20THEiv+g2HScgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 04 Nov 2021 15:37:15 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 9e2b5671;
        Thu, 4 Nov 2021 15:37:14 +0000 (UTC)
Date:   Thu, 4 Nov 2021 15:37:14 +0000
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] ceph: metrics for remote object copies
Message-ID: <YYP+KrFWyLmfKY9v@suse.de>
References: <20211104123147.1632-1-lhenriques@suse.de>
 <b2fcd4ff9dd84ceb90650d24b56bd704985c85b8.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b2fcd4ff9dd84ceb90650d24b56bd704985c85b8.camel@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Nov 04, 2021 at 11:09:32AM -0400, Jeff Layton wrote:
> On Thu, 2021-11-04 at 12:31 +0000, Luís Henriques wrote:
> > Hi!
> > 
> > Here's v2 of this patchset.  The differences from v1:
> > 
> >   * Instead of changing ceph_osdc_copy_from() in libceph.ko to return an
> >     osd request, move that function into the cephfs code instead.
> > 
> > Other than that, the 2nd patch is quite similar to the one from v1: it
> > effectively hooks the 'copyfrom' metrics infrastructure.
> > 
> > Luís Henriques (2):
> >   ceph: libceph: move ceph_osdc_copy_from() into cephfs code
> >   ceph: add a new metric to keep track of remote object copies
> > 
> >  fs/ceph/debugfs.c               |  3 +-
> >  fs/ceph/file.c                  | 78 ++++++++++++++++++++++++++++-----
> >  fs/ceph/metric.h                |  8 ++++
> >  include/linux/ceph/osd_client.h | 19 ++++----
> >  net/ceph/osd_client.c           | 60 ++++---------------------
> >  5 files changed, 94 insertions(+), 74 deletions(-)
> > 
> 
> Looks good. Thanks, Luis. Merged into testing branch.

Awesome, thanks.  I'll wait until this is merged into mainline (which will
take a while, of course) before I push changes to the fstests.  Adding
further checks to the tests that use remote copies was the drive for these
new metrics, and I've already some patches for doing that.  They'll need
some cleanup but it doesn't make sense to push them before this is
available upstream.

Cheers,
--
Luís
