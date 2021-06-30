Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E0B3B81A5
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jun 2021 14:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhF3MHf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Jun 2021 08:07:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234419AbhF3MHe (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 08:07:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34E176161E;
        Wed, 30 Jun 2021 12:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625054705;
        bh=85tPoQG8V5bE6iFere7e1etfXqXNaut4wYKcAE5Ns4M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bTFEuM7WDSvL5o0094uzm3AD1T+aRYNH78/uiSAhNqh/DQNVw4C+ZLxyLV1Wvj8+8
         CueoHNEadijRyRh/fGbtyLneThUy6FI84HZAOyouZGF8Dr84Ity5Ve0wHWTkOWh7U9
         Mo3+7aprZX93e8SlKxa5PAgWegXgTOXxnGvZKpLeEHf6oQQYVFchNVzZyJi37TMZwF
         ndTxjHDKgLvokYaYj/kPJaxdnHTF+aISY5NSOGvv9M478v2S9STe6CmT0iv47vMrRP
         g4RXqYcXemPgK/dLZyf+x8voMMBRwefJcitgfPKgfNeNgNj0JhebGe72ol+Iya9uX1
         csoc1qIEVJpIw==
Message-ID: <7d4b7f733b07efff86caa69e290104e5855ba074.camel@kernel.org>
Subject: Re: [PATCH 5/5] ceph: fix ceph feature bits
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 30 Jun 2021 08:05:04 -0400
In-Reply-To: <d91f6786-24fd-e3a9-4fe8-d55821382940@redhat.com>
References: <20210629044241.30359-1-xiubli@redhat.com>
         <20210629044241.30359-6-xiubli@redhat.com>
         <d98d4f50cdad747313e6d9a8a42691962fdcd0ae.camel@kernel.org>
         <d91f6786-24fd-e3a9-4fe8-d55821382940@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-06-30 at 08:52 +0800, Xiubo Li wrote:
> On 6/29/21 11:38 PM, Jeff Layton wrote:
> > On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/mds_client.h | 4 ++++
> > >   1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > index 79d5b8ed62bf..b18eded84ede 100644
> > > --- a/fs/ceph/mds_client.h
> > > +++ b/fs/ceph/mds_client.h
> > > @@ -27,7 +27,9 @@ enum ceph_feature_type {
> > >   	CEPHFS_FEATURE_RECLAIM_CLIENT,
> > >   	CEPHFS_FEATURE_LAZY_CAP_WANTED,
> > >   	CEPHFS_FEATURE_MULTI_RECONNECT,
> > > +	CEPHFS_FEATURE_NAUTILUS,
> > >   	CEPHFS_FEATURE_DELEG_INO,
> > > +	CEPHFS_FEATURE_OCTOPUS,
> > >   	CEPHFS_FEATURE_METRIC_COLLECT,
> > >   
> > >   	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
> > > @@ -43,7 +45,9 @@ enum ceph_feature_type {
> > >   	CEPHFS_FEATURE_REPLY_ENCODING,		\
> > >   	CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
> > >   	CEPHFS_FEATURE_MULTI_RECONNECT,		\
> > > +	CEPHFS_FEATURE_NAUTILUS,		\
> > >   	CEPHFS_FEATURE_DELEG_INO,		\
> > > +	CEPHFS_FEATURE_OCTOPUS,			\
> > >   	CEPHFS_FEATURE_METRIC_COLLECT,		\
> > >   						\
> > >   	CEPHFS_FEATURE_MAX,			\
> > Do we need this? I thought we had decided to deprecate the whole concept
> > of release-based feature flags.
> 
> This was inconsistent with the MDS side, that means if the MDS only 
> support CEPHFS_FEATURE_DELEG_INO at most in lower version of ceph 
> cluster, then the kclients will try to send the metric messages to 
> MDSes, which could crash the MDS daemons.
> 
> For the ceph version feature flags they are redundant since we can check 
> this from the con's, since pacific the MDS code stopped updating it. I 
> assume we should deprecate it since Pacific ?
> 

I believe so. Basically the version-based features aren't terribly
useful. Mostly we want to check feature flags for specific features
themselves. Since there are no other occurrences of
CEPHFS_FEATURE_NAUTILUS or CEPHFS_FEATURE_OCTOPUS symbols, it's probably
best not to define them at all.

-- 
Jeff Layton <jlayton@kernel.org>

