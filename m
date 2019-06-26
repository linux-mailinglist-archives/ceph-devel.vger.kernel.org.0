Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06AB6561BB
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jun 2019 07:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbfFZFeS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jun 2019 01:34:18 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38578 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfFZFeS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jun 2019 01:34:18 -0400
Received: by mail-qk1-f196.google.com with SMTP id a27so659284qkk.5
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 22:34:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KVcdiE46g70z36tGpeTtUHq/+iTFd2KPtpdZ7fn336E=;
        b=iUa9qCUipd7NefEnKT5tVAEPK3iPJLv66ScP/hTnnU5bPcvJrWqQ4fW7ccR0vqlTy3
         eI1mWRxpc4HLsqAQuR/XIPcQJqg7V0bOhn1GTFOc7el9ZIU5rXagRV4DrG9A03KXba1N
         3VJU7rKDyN0HpM2h53zPOGV7Sa+F7+IRNNtbIttZAKqLCuPEMav28IOWt95G6UITLVml
         4aRTJKTT8FwKyjpqfFARNfhzPgJPMY5tl6sCPSTu2551QSdE4NY1CbWe7vsYfqoy5hI0
         D4maVzkZZyIGFoVJAnaKlCmNUbqKbXf/b5RpohlhmD6S3xNJPrj2Uoi4WfNTIoTUYOJ4
         EHJg==
X-Gm-Message-State: APjAAAXANYbcEcPsC42A5B6vbaxeKhk/Dpqdem7mgMACPOf0AtKgA2wJ
        3lW2g2p1gFO5aJ0D7tEbFooLU5QOQe351etHREbvtg==
X-Google-Smtp-Source: APXvYqxhIAgq6KGOWG61e4+MQlFLFuwP1Fm8CF1bRBWNbC2cy9ch/UJVvBrmYfAniDXfaD1qLdWmYATXE3h8CImlSQU=
X-Received: by 2002:a05:620a:12f8:: with SMTP id f24mr2341900qkl.202.1561527257200;
 Tue, 25 Jun 2019 22:34:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190617125529.6230-1-zyan@redhat.com> <20190617125529.6230-5-zyan@redhat.com>
 <86f838f18f0871d6c21ae7bfb97541f1de8d918f.camel@redhat.com>
 <3b0a4024-d47e-0a3f-48ca-0f1f657e9da9@redhat.com> <e220f9e72b736141c39da52eb7d8d00b97a2c040.camel@redhat.com>
 <CAAM7YAmaQ6eC_zcC7xFr9c6XMOsJvR=TFXZ__i_+jnxQf5MmtA@mail.gmail.com>
 <03262ecae2386444d50571484fbe21592d4d3f95.camel@redhat.com>
 <d45fef05-5b6c-5919-fa0f-98e900c7f05b@redhat.com> <2cc051f6e86201ddd524b2bf6f3b04ddb89c9d36.camel@redhat.com>
 <15e9508d-903b-ae32-7c6d-11b23d20e19d@redhat.com> <CA+2bHPZh153dstOHPucamuPRS8nd37LjKm6uUf5n4B+T_ckVXA@mail.gmail.com>
 <e0604e462e8e6c6ddae0d000634723f87d4deb69.camel@redhat.com>
 <CAAM7YAns+NmdjJf7wvzj90ZqtrXEiOsLNgevbho4uuqv2dp5RQ@mail.gmail.com>
 <d0f64c7338af712fe074b06ebfea06b968ea6ba6.camel@redhat.com> <bc16766e-4f3b-71b0-f03b-6ac279c665ab@redhat.com>
In-Reply-To: <bc16766e-4f3b-71b0-f03b-6ac279c665ab@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Tue, 25 Jun 2019 22:33:50 -0700
Message-ID: <CA+2bHPYx=nKux9FihOfeestOU_M2uY3BpvWKm2h9ts0o54yghQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] ceph: allow remounting aborted mount
To:     "Yan, Zheng" <zyan@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>, "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 25, 2019 at 10:16 PM Yan, Zheng <zyan@redhat.com> wrote:
> On 6/25/19 9:39 PM, Jeff Layton wrote:
> > In any case, I thought blacklisting mostly occurred when clients fail to
> > give up their MDS caps. Why would repeated polling create more blacklist
> > entries?
> >
>
> mds blacklist client when client is unresponsive. The blacklist entry
> stays in osdmap for a day. If client auto reconnect, a laggy client can
> keep reconnecting and getting blacklisted.

We can address this problem in two directions:

1) MDS simply rejects a client session from a certain IP address if
the MDS has been repeatedly blacklisting clients from that IP. If the
client never has a new session, there is no need add a new blacklist
entry.

2) The client can be smarter and not retry connections if it has been
blacklisted ~3 times in the last hour. (Just be sure to log that it is
deferring reconnect until later when it thinks the session will be
successful.)

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
