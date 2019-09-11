Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7929DB03A5
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 20:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729859AbfIKSa0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Sep 2019 14:30:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbfIKSaZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Sep 2019 14:30:25 -0400
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 949E4AD880
        for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2019 18:30:25 +0000 (UTC)
Received: by mail-qk1-f198.google.com with SMTP id z128so13576031qke.8
        for <ceph-devel@vger.kernel.org>; Wed, 11 Sep 2019 11:30:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vr25q8HXRs/5Z/IQGtPD0824c39CxA4jNiAmKfLKcxc=;
        b=CbnrkPz9Fgq5WjDlgJgzMrzSvRhUhu7lWfxTGxiiz0jV8IAll0haJh4iGB6Ehz/cmx
         477QD5pgVj/qxIoPQN3rXCbojQwP5lxs/IZ4+Nj+2Wzz3+hP9HcfW2XO3lmptwGmL9oH
         yxtRfsLpG1W/rOoaDDqBgbM3UsUmv2eq3nIPBu6dGPE5/KVHfpegupH6iTgxl+6bTgHG
         E6uU3SaJmrUmC67ZMx12ojUO1rf/aJ6CdwEKodyMjW9YUluZl5Teguf7FD7lulQlcEWU
         0iuqNMppS+7QlxHWFvCcCMGZ/Dwn+I1O8hi4BY7kPMk4JubIdUy/5YhNgZ0yciSr1e8W
         ZrbQ==
X-Gm-Message-State: APjAAAWd8xtDAyEKjJoo2UH+2x+Z/m2EzwbX1A/Se4EG9Ot89S7GqWw+
        AkbqxbTuzcx5sS4NQQ77FTijYBdX1/+HC7MYIyJ4nQ7n9t+1MNjEbWOgk9DSBP1Aju9o923xfkQ
        gKNUhoWeLl0DA4KWfSWZdXZGhQ3YKwj8yzkX+lQ==
X-Received: by 2002:a37:49d6:: with SMTP id w205mr36858422qka.191.1568226624492;
        Wed, 11 Sep 2019 11:30:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyKyhS4a9dt2TReEq1jLkbiviLyRQ0s5Z8qmT7e2RfsRbYaNoexlLBZWl4mJUsQQp6n4bEx/q1CdvCTq4Uphzg=
X-Received: by 2002:a37:49d6:: with SMTP id w205mr36858356qka.191.1568226623926;
 Wed, 11 Sep 2019 11:30:23 -0700 (PDT)
MIME-Version: 1.0
References: <1568083391-920-1-git-send-email-simon29rock@gmail.com> <e413734270fc43cabbf9df09b0ed4bff06a96699.camel@kernel.org>
In-Reply-To: <e413734270fc43cabbf9df09b0ed4bff06a96699.camel@kernel.org>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Wed, 11 Sep 2019 11:30:13 -0700
Message-ID: <CAJ4mKGbY+veWdLv588Hz4mQidz5ofiGemOQ2Nwx_M6XN0WXGJw@mail.gmail.com>
Subject: Re: [PATCH] ceph: add mount opt, always_auth
To:     Jeff Layton <jlayton@kernel.org>
Cc:     simon gao <simon29rock@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Sep 10, 2019 at 3:11 AM Jeff Layton <jlayton@kernel.org> wrote:
> I've no particular objection here, but I'd prefer Greg's ack before we
> merge it, since he raised earlier concerns.

You have my acked-by in light of Zheng's comments elsewhere and the
evidence that this actually works in some scenarios.

Might be nice to at least get far enough to generate tickets based on
your questions in the other thread, though:

On Wed, Sep 11, 2019 at 9:26 AM Jeff Layton <jlayton@kernel.org> wrote:
> In an ideal world, what should happen in this case? Should we be
> changing MDS policy to forward the request in this situation?
>
> This mount option seems like it's exposing something that is really an
> internal implementation detail to the admin. That might be justified,
> but I'm unclear on why we don't expect more saner behavior from the MDS
> on this?

I think partly it's that early designs underestimated the cost of
replication and overestimated its utility, but I also thought forwards
were supposed to happen more often than replication so I'm curious why
it's apparently not doing that.
-Greg
