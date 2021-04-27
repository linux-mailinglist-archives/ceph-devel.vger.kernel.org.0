Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B0036CB3F
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Apr 2021 20:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbhD0Sn1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Apr 2021 14:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236962AbhD0Sn0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 14:43:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E23F613F7;
        Tue, 27 Apr 2021 18:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619548962;
        bh=II39dOP/yjCaBOU2RIAwuLTq2wGtiptanicm+rKDgRc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fEzMf/iHSZMAS9Q9GLwz+ITIGrwdennGuidgeXO7U3qeFBt482GpeAe2HfPGSS8fA
         w7R65TnGMpE794q3YwiRGLiFhsmLG1IFro0qamBk2nfPtJixv1uVuFnm4NMC64yt9p
         7r2JC3cBuPcRS2hUsSTQnzQW6X/POHOuahebM7QIztUxOfnH5cpKEFQ7qNrRT08GOv
         ehOiMIb2H5KPfxfaU1TOQkxyarM+UGeVWLIDL5EEzsFyzEI9JmrYYYF0XrvCNsOwwf
         Y7VExHIp82Kn7WsbXImLeCWKH80gWupqdNK06KthmoZRv8kYhqDtcQjLw6i25OHJgH
         13CQW6shGH7aA==
Message-ID: <9930d9e82776a3a3d314275a2c57d4b1890fa9cc.camel@kernel.org>
Subject: Re: [PATCH v3] libceph: add osd op counter metric support
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Xiubo Li <xiubli@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Tue, 27 Apr 2021 14:42:41 -0400
In-Reply-To: <CAOi1vP-RfOtZiCpnBb9jiHWJqepXG0+T7y7O=YjYfE9W5Mx9SA@mail.gmail.com>
References: <20201110141937.414301-1-xiubli@redhat.com>
         <CAOi1vP-tBRNEgkmhvieUyBzOms-n=vge4XpYSpnU6cnq86SRMQ@mail.gmail.com>
         <96d573ba-c82c-a22a-ee9d-bbc2156910ab@redhat.com>
         <7a63b9bd92cf3cd9f05530157fcc5d3d90b31b9e.camel@kernel.org>
         <CAOi1vP-RfOtZiCpnBb9jiHWJqepXG0+T7y7O=YjYfE9W5Mx9SA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-04-26 at 22:33 +0200, Ilya Dryomov wrote:
> On Mon, Apr 26, 2021 at 7:56 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > On Wed, 2020-11-11 at 09:32 +0800, Xiubo Li wrote:
> > > On 2020/11/10 23:44, Ilya Dryomov wrote:
> > > > On Tue, Nov 10, 2020 at 3:19 PM <xiubli@redhat.com> wrote:
> > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > 
> > > > > The logic is the same with osdc/Objecter.cc in ceph in user space.
> > > > > 
> > > > > URL: https://tracker.ceph.com/issues/48053
> > > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > > ---
> > > > > 
> > > > > V3:
> > > > > - typo fixing about oring the _WRITE
> > > > > 
> > > > >   include/linux/ceph/osd_client.h |  9 ++++++
> > > > >   net/ceph/debugfs.c              | 13 ++++++++
> > > > >   net/ceph/osd_client.c           | 56 +++++++++++++++++++++++++++++++++
> > > > >   3 files changed, 78 insertions(+)
> > > > > 
> > > > > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > > > > index 83fa08a06507..24301513b186 100644
> > > > > --- a/include/linux/ceph/osd_client.h
> > > > > +++ b/include/linux/ceph/osd_client.h
> > > > > @@ -339,6 +339,13 @@ struct ceph_osd_backoff {
> > > > >          struct ceph_hobject_id *end;
> > > > >   };
> > > > > 
> > > > > +struct ceph_osd_metric {
> > > > > +       struct percpu_counter op_ops;
> > > > > +       struct percpu_counter op_rmw;
> > > > > +       struct percpu_counter op_r;
> > > > > +       struct percpu_counter op_w;
> > > > > +};
> > > > OK, so only reads and writes are really needed.  Why not expose them
> > > > through the existing metrics framework in fs/ceph?  Wouldn't "fs top"
> > > > want to display them?  Exposing latency information without exposing
> > > > overall counts seems rather weird to me anyway.
> > > 
> > > Okay, I just thought in future this may also be needed by rbd :-)
> > > 
> > > 
> > > > The fundamental problem is that debugfs output format is not stable.
> > > > The tracker mentions test_readahead -- updating some teuthology test
> > > > cases from time to time is not a big deal, but if a user facing tool
> > > > such as "fs top" starts relying on these, it would be bad.
> > > 
> > > No problem, let me move it to fs existing metric framework.
> > > 
> > 
> > Hi Xiubo/Ilya/Patrick :
> > 
> > Mea culpa...I had intended to drop this patch from testing branch after
> > this discussion, but got sidetracked and forgot to do so. I've now done
> > that though.
> 
> On the subject of metrics, I think Xiubo's I/O size metrics patches
> need a look -- he reposted the two that were skipped a while ago.
> 

Thanks for reminding me. I saw that he sent those when I was OOTO, and I
forgot to revisit them. In the future, if I do that, ping me about them
and I'll try to get to them sooner.
-- 
Jeff Layton <jlayton@kernel.org>

