Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96763BB716
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Sep 2019 16:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438401AbfIWOs4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Sep 2019 10:48:56 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:37699 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438382AbfIWOs4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 23 Sep 2019 10:48:56 -0400
Received: by mail-qk1-f175.google.com with SMTP id u184so15685593qkd.4
        for <ceph-devel@vger.kernel.org>; Mon, 23 Sep 2019 07:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=leblancnet-us.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kRaauf8t1QzhipUvn5MKoGAbBCtNcMGjbLlbQ1mo69E=;
        b=jV2tZ0JLYdYtgi4vM9N/bQADcoxCtIudWEcTsQkmHHzqGr4v0iXFKDHzlN5mOQxy+3
         zOZ6a+hqNE0NLTOMpy4AfNbzvsLPCNkFUIyRDzYpj+twb3eNgyATh1Ym8/ZFAvVnLhV+
         jOrPoDq0ngF2QUiuVe3haAaEsWH1IR4hQ2o7KaenJmwlJLzslsj903APzT0V+BFnUCUZ
         h8ggoWRp1l6pkTFK7MwRrFkKREQ2qO5/AnxHt384KXnpGuLT63CPBw1NK3GRXhfJyr9n
         LGUYnUpjUC5vAFfw5+QdkfitODfNT8q6mLlET8Pltyb6zdMoQZcCDP8rylxVuui1lb8P
         x8gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kRaauf8t1QzhipUvn5MKoGAbBCtNcMGjbLlbQ1mo69E=;
        b=KK2FAGDaLD0p5+FqXdiD9g6psN4hGHQv+5utRvCll0/sQYRPFQCoWDkL1siFR6yu5o
         VUDtFJUh4VP+JjcM2XywLC7XY0P+np8NjYnc6NRAyeC7zalQgM4fWKVZaX5qR5AZd1cY
         IXZA8VyjkMZaLsCmmA08iGspSzXFH9o470Gr6AADh4dcZ/Q6iFf7afR7/TJrFPA7HLjb
         DeQrciKVIKLSHwVLA+J9fkLPdvxy0tH/HhNKPzA3SKJyWNdwgaoz41NRjqWpSG/M5+wb
         gRy4eet3gC6YExQAig3/cZsQ4oyeGF0uFRrxg6oNAoprnyzomzEy8DAlWnQMrMwCtT2a
         EQLg==
X-Gm-Message-State: APjAAAV16lGtylk6kVfBg0sN1sexG22rFOGrdZZ/mEPAxV9cBmMuvhGL
        AR2ORcc/WK1fb0qkGf7xYRzUntrzSU7NDa09vl7AeMA2+VU=
X-Google-Smtp-Source: APXvYqywhtGTjuj41Zhd5HFiAY3vnozN9PibLEZw4v0osVqsY+1ThAiD1BnC75TkY/A36F2/tIwM7fiKhYeQJk/gUPQ=
X-Received: by 2002:ae9:dd07:: with SMTP id r7mr180493qkf.248.1569250133844;
 Mon, 23 Sep 2019 07:48:53 -0700 (PDT)
MIME-Version: 1.0
References: <CANA9Uk7nUFcLc7L4-=3hGH-7Dcf4dt1+xVSrs7hDzgWdNB+vqw@mail.gmail.com>
In-Reply-To: <CANA9Uk7nUFcLc7L4-=3hGH-7Dcf4dt1+xVSrs7hDzgWdNB+vqw@mail.gmail.com>
From:   Robert LeBlanc <robert@leblancnet.us>
Date:   Mon, 23 Sep 2019 07:48:42 -0700
Message-ID: <CAANLjFq3HCJvd6R-17ip+-TqTYeQFk0Z2eSz+hkCr2B4jUyX7w@mail.gmail.com>
Subject: Re: [ceph-users] ceph; pg scrub errors
To:     M Ranga Swami Reddy <swamireddy@gmail.com>
Cc:     ceph-users <ceph-users@lists.ceph.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Sep 19, 2019 at 4:34 AM M Ranga Swami Reddy
<swamireddy@gmail.com> wrote:
>
> Hi-Iam using ceph 12.2.11. here I am getting a few scrub errors. To fix these scrub error I ran the "ceph pg repair <pg_id>".
> But scrub error not going and the repair is talking long time like 8-12 hours.

Depending on the size of the PGs and how active the cluster is, it
could take a long time as it takes another deep scrub to happen to
clear the error status after a repair. Since it is not going away,
either the problem is too complicated to automatically repair and
needs to be done by hand, or the problem is repaired and when it
deep-scrubs to check it, the problem has reappeared or another problem
was found and the disk needs to be replaced.

Try running:
rados list-inconsistent-obj ${PG} --format=json

and see what the exact problems are.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
