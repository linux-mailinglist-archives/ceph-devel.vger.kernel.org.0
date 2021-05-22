Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631D138D5C4
	for <lists+ceph-devel@lfdr.de>; Sat, 22 May 2021 14:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhEVMRJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 22 May 2021 08:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230402AbhEVMRH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 22 May 2021 08:17:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BE246128A;
        Sat, 22 May 2021 12:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621685742;
        bh=MNFrr7ocAncvydGR4ShcOq+K+oWKjIUClc+sWWP4RKo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TbVUFI0eQ3bjh05NeyiKJmJVBTYWU8yGmyu84x9Qa1GB/iR5olP7DHx8yh3il5TP7
         weksFicZ2EBgVrk1dDxdZjwEE1qXThwmJsbHPAglr/SmrdTTC6Mh4nm877hSJg8jZw
         Z8V3Q5acz47zKVsXlKWQT+Ti6bTwqcWQDVeDwMOoX3MqHHlqNDNHlUej3YX2XhdXkY
         FoGzH/klcwjg0RdJrAovCrWZs62xc9fd9JXAbUwQnZqhwhLsPezC1uWwYeaYo4bqCs
         SaUPIrFUtnlA0pMU8idd7yPpleQ2RfxoaVJQ6CoQ3M084Z7GjDvi05j6SLTRdS0Lhn
         ESVmVJTWrbekA==
Message-ID: <e1d3be523b2571ddd1cea354be525b596938bad1.camel@kernel.org>
Subject: Re: [PATCH v2 0/2] ceph: send io size metrics to mds daemon
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Sat, 22 May 2021 08:15:41 -0400
In-Reply-To: <04b4b11c-0411-cacd-9504-36be3437169c@redhat.com>
References: <20210513014053.81346-1-xiubli@redhat.com>
         <89def1a8e65e443ba7aca7c4ff138e6c6041a5df.camel@kernel.org>
         <70554cca-9985-338c-de04-4053a4a04872@redhat.com>
         <CAOi1vP-dpSUO5F_cyhzBycvuCp6N2cRPifJPAZ1Ybws+T=pGcA@mail.gmail.com>
         <de9304d8-8428-5634-24ec-fdae07b9ec24@redhat.com>
         <7a9d7350f30ee91138876b7330324db582713ee8.camel@kernel.org>
         <04b4b11c-0411-cacd-9504-36be3437169c@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-05-18 at 09:00 +0800, Xiubo Li wrote:
> On 5/17/21 11:46 PM, Jeff Layton wrote:
> > On Fri, 2021-05-14 at 17:14 +0800, Xiubo Li wrote:
> > > On 5/14/21 4:57 PM, Ilya Dryomov wrote:
> > > > On Fri, May 14, 2021 at 2:47 AM Xiubo Li <xiubli@redhat.com> wrote:
> > > > > On 5/13/21 7:30 PM, Jeff Layton wrote:
> > > > > > On Thu, 2021-05-13 at 09:40 +0800, xiubli@redhat.com wrote:
> > > > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > > > 
> > > > > > > V2:
> > > > > > > - change the patch order
> > > > > > > - replace the fixed 10 with sizeof(struct ceph_metric_header)
> > > > > > > 
> > > > > > > Xiubo Li (2):
> > > > > > >      ceph: simplify the metrics struct
> > > > > > >      ceph: send the read/write io size metrics to mds
> > > > > > > 
> > > > > > >     fs/ceph/metric.c | 90 ++++++++++++++++++++++++++++++------------------
> > > > > > >     fs/ceph/metric.h | 79 +++++++++++++++++-------------------------
> > > > > > >     2 files changed, 89 insertions(+), 80 deletions(-)
> > > > > > > 
> > > > > > Thanks Xiubo,
> > > > > > 
> > > > > > These look good. I'll do some testing with them and plan to merge these
> > > > > > into the testing branch later today.
> > > > > Sure, take your time.
> > > > FYI I squashed "ceph: send the read/write io size metrics to mds" into
> > > > "ceph: add IO size metrics support".
> > I've dropped this combined patch for now, as it was triggering an MDS
> > assertion that was hampering testing [1]. I'll plan to add it back once
> > that problem is resolved in the MDS.
> > 
> > [1]: https://github.com/ceph/ceph/pull/41357
> > 
> > Cheers,
> 
> Ack. Thanks.
> 
> 

Patrick mentioned that the problem with the MDS has now been resolved,
so I've gone ahead and merged this patch back into testing branch. Let
me know if you see any more issues.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

