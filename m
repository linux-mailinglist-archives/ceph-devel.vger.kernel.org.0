Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2EA43838A6
	for <lists+ceph-devel@lfdr.de>; Mon, 17 May 2021 18:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241409AbhEQP6V (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 May 2021 11:58:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343664AbhEQPwK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 May 2021 11:52:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF30061184;
        Mon, 17 May 2021 15:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621266385;
        bh=YNXNL5R09AGGaM6l8r8DFtebQDtwqo0AL06f35MJtNQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EOo1rOZULVoYy0kqqoHHb3mEZMtJ8q2hAUovKVuxfKxuamp/Rd4dhgT11MJiGebLE
         udTKFP4l06GwbdIdO6Lpyn1tZQGmqWYRqnpn14ZSGSIbvLXd8Dj5PSH5CRinN7K+uY
         5ONou8S9CB6gq5ojr78m6/u6TRKlF7sAoYhUiyxny6xWAtuDcpdF2dLNVmmh5P/5ku
         OOgJ8qfg7Tez+XiVxnzuzuB2no0ZIdrM0yxpRPqyBBtlkb1yYTwrA0KiRJ+HAnXaDJ
         PKsXfSk9PkhXDxSxu4oEsAR5a9lw2WwwldqgpUTmg0f3xvvsBbIkjFrTCbChJqAOYu
         wcgRW8yBu46gQ==
Message-ID: <7a9d7350f30ee91138876b7330324db582713ee8.camel@kernel.org>
Subject: Re: [PATCH v2 0/2] ceph: send io size metrics to mds daemon
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Mon, 17 May 2021 11:46:23 -0400
In-Reply-To: <de9304d8-8428-5634-24ec-fdae07b9ec24@redhat.com>
References: <20210513014053.81346-1-xiubli@redhat.com>
         <89def1a8e65e443ba7aca7c4ff138e6c6041a5df.camel@kernel.org>
         <70554cca-9985-338c-de04-4053a4a04872@redhat.com>
         <CAOi1vP-dpSUO5F_cyhzBycvuCp6N2cRPifJPAZ1Ybws+T=pGcA@mail.gmail.com>
         <de9304d8-8428-5634-24ec-fdae07b9ec24@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-05-14 at 17:14 +0800, Xiubo Li wrote:
> On 5/14/21 4:57 PM, Ilya Dryomov wrote:
> > On Fri, May 14, 2021 at 2:47 AM Xiubo Li <xiubli@redhat.com> wrote:
> > > 
> > > On 5/13/21 7:30 PM, Jeff Layton wrote:
> > > > On Thu, 2021-05-13 at 09:40 +0800, xiubli@redhat.com wrote:
> > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > 
> > > > > V2:
> > > > > - change the patch order
> > > > > - replace the fixed 10 with sizeof(struct ceph_metric_header)
> > > > > 
> > > > > Xiubo Li (2):
> > > > >     ceph: simplify the metrics struct
> > > > >     ceph: send the read/write io size metrics to mds
> > > > > 
> > > > >    fs/ceph/metric.c | 90 ++++++++++++++++++++++++++++++------------------
> > > > >    fs/ceph/metric.h | 79 +++++++++++++++++-------------------------
> > > > >    2 files changed, 89 insertions(+), 80 deletions(-)
> > > > > 
> > > > Thanks Xiubo,
> > > > 
> > > > These look good. I'll do some testing with them and plan to merge these
> > > > into the testing branch later today.
> > > Sure, take your time.
> > FYI I squashed "ceph: send the read/write io size metrics to mds" into
> > "ceph: add IO size metrics support".
> 

I've dropped this combined patch for now, as it was triggering an MDS
assertion that was hampering testing [1]. I'll plan to add it back once
that problem is resolved in the MDS.

[1]: https://github.com/ceph/ceph/pull/41357

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

