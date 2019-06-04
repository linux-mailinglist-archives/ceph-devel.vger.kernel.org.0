Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 095043507B
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 21:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfFDTzG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Tue, 4 Jun 2019 15:55:06 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:37011 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFDTzG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 15:55:06 -0400
Received: by mail-qk1-f175.google.com with SMTP id d15so3670532qkl.4
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2019 12:55:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DWgkbzxE3+jbV7Jm4wVTWLqoM+kh0zFLnWLdmMk+Dzs=;
        b=aU44t3sHkM5otWWryKC8KH0S6qMhMyaRp3uZX/rsZV9k/lHBVOyh/VqhtF0WkMVceI
         otAm9BUDZCftw/oq0A2+VSctw/evIum3H4r8yYd2K27kxrhiWWSmZfWUD+Jq/N8A5HLb
         bhaYHAFBxbnPCXhx1Z78WUtQPi3dj6pqiMelQxgII1zR0dHMkqg/pBtvD4t/Bgcf80Rc
         Z6TDfzv50uAX71P+L2ZTCk211MzEE7oIiIzSbax42uwUJHVUlnIIbSTlKCpHx/gxxKLS
         QVf9/KOmn1WebmwcUWVw2aGhEu/hhg1QwMqT3kwrgRd59fosDz8ZS6NOHcZNLYENruv2
         h35A==
X-Gm-Message-State: APjAAAVPcgy9eMekxnNV9FeuPbDrI8bBxJ7zTK9d7OYPbqOpXidnIrDw
        N1akFzrWyyKndiuDux2T16rdhwSszO49JNAsLsjKNDWU
X-Google-Smtp-Source: APXvYqxiRV8piZy9sh2e2vSVq4ey24Cm8Tikvb9cHMDtDFZxTe9K544ShW988TEwNr4S1Z8rFQIaQA/MUcwBIiMoDaw=
X-Received: by 2002:a37:c408:: with SMTP id d8mr20631476qki.18.1559678105278;
 Tue, 04 Jun 2019 12:55:05 -0700 (PDT)
MIME-Version: 1.0
References: <201906041410415357069@zte.com.cn>
In-Reply-To: <201906041410415357069@zte.com.cn>
From:   Neha Ojha <nojha@redhat.com>
Date:   Tue, 4 Jun 2019 12:54:54 -0700
Message-ID: <CAKn7kBk6-WcLPpOR7E-4SqZSDzNDJbDVXtivmX=XWxPES1whxQ@mail.gmail.com>
Subject: Re: About the partial recovery
To:     xie.xingguo@zte.com.cn
Cc:     Josh Durgin <jdurgin@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Xie,

Find my response inline.

On Mon, Jun 3, 2019 at 11:11 PM <xie.xingguo@zte.com.cn> wrote:
>
> Josh & Neha,
>
>          The partial recovery (https://github.com/ceph/ceph/pull/21722, I'd consider "incremental recovery" a better naming btw)
>
> has been merged into master a couple of weeks ago, which is great.
>
>           However, I don't really like the way it tracing the modified content very much - it actually traces the unmodifed/clean parts of the specific object instead,
>
> which is neither straightforward nor super efficient.
>
>           Can we change the design to record dirty regions instead? There should be two benefits I can think of by doing so:

In order to do any kind of partial(or incremental) recovery we need to
keep track of dirty/clean regions, the PR we merged chose to track
clean regions. If you can make a case for using dirty regions instead
by a) coming up with an implementation b) backing it up with reason
and numbers that can prove that it is better, we'll be happy to take a
look at it.

>
>           1、dirty_regions are smaller (should always be == clean_regions.size() - 1), which as a result can save us approximate
>
>                 3000 (pg log entries) * 16 * 100 (100 pg per osd) = 4MB memory as well as bluestore.db space
>
>           2、we can re-use the existing modified_ranges of OpContext to trace the data regions modified by an op

This sounds like a good idea to me.

Thanks,
Neha
>
>
> What do you think?
>
>
>
>
>
