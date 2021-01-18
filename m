Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA842F9DAB
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Jan 2021 12:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389909AbhARLJd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Jan 2021 06:09:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:54116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389899AbhARLJ0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 18 Jan 2021 06:09:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8714221F8;
        Mon, 18 Jan 2021 11:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610968125;
        bh=6szuVSnV5MOmY/O/uZpCkdWt31KDBQz1fL3d/ijZuXQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=P9dOV2ezMAMNjtyfAg5+zeIb/+bZRkgQ4BGrj/1cHQhu4DL50IQQfXyfuBi1Mfhxx
         OpDTk8ymVhijDPBntFY9VHQdGviT0UyDyrJtFOp3OCYT0x0VPrJPTc2Po4K6gVhp0x
         76sL5PNaqyhO7FmT2RwWucwPBytbNawXpEfe5TJMwuNRSX0jq8IMu1FlSDUKlYyzGK
         LC0RkWtSHjyExjnxYOiXOnRn62weqc8g/WVX8lHqkD5AKOD1svADzJTCvysbWtcxtA
         L1g+00CgdoA0ABQslAhpPWAhf5hfRHV9U38kZ1NrD3VApijazPsTu7mlddTgw1q0Bj
         E8vmpjk5kbWOw==
Message-ID: <5a6fd5f3ab30fe04332bc4af4ecdeaca7fd501c0.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: defer flushing the capsnap if the Fb is used
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 18 Jan 2021 06:08:43 -0500
In-Reply-To: <376245cf-a60d-6ddb-6ab3-894a491b854e@redhat.com>
References: <20210110020140.141727-1-xiubli@redhat.com>
         <f698d039251d444eec334b119b5ae0b0dd101a21.camel@kernel.org>
         <376245cf-a60d-6ddb-6ab3-894a491b854e@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-01-18 at 17:10 +0800, Xiubo Li wrote:
> On 2021/1/13 5:48, Jeff Layton wrote:
> > On Sun, 2021-01-10 at 10:01 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > If the Fb cap is used it means the current inode is flushing the
> > > dirty data to OSD, just defer flushing the capsnap.
> > > 
> > > URL: https://tracker.ceph.com/issues/48679
> > > URL: https://tracker.ceph.com/issues/48640
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > > 
> > > V3:
> > > - Add more comments about putting the inode ref
> > > - A small change about the code style
> > > 
> > > V2:
> > > - Fix inode reference leak bug
> > > 
> > >   fs/ceph/caps.c | 32 +++++++++++++++++++-------------
> > >   fs/ceph/snap.c |  6 +++---
> > >   2 files changed, 22 insertions(+), 16 deletions(-)
> > > 
> > Hi Xiubo,
> > 
> > This patch seems to cause hangs in some xfstests (generic/013, in
> > particular). I'll take a closer look when I have a chance, but I'm
> > dropping this for now.
> 
> Okay.
> 
> BTW, what's your test commands to reproduce it ? I will take a look when 
> I am free these days or later.
> 
> BRs
> 

I set up xfstests to run on cephfs, and then just run:

    $ sudo ./check generic/013

It wouldn't reliably complete with this patch in place. Setting up
xfstests is the "hard part". I'll plan to roll up a wiki page on how to
do that soon (that's good info to have out there anyway).
> 

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

