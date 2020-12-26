Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8A22E2D1B
	for <lists+ceph-devel@lfdr.de>; Sat, 26 Dec 2020 05:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgLZEsL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 25 Dec 2020 23:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgLZEsL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 25 Dec 2020 23:48:11 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB82C0613C1
        for <ceph-devel@vger.kernel.org>; Fri, 25 Dec 2020 20:47:31 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id n9so5172180ili.0
        for <ceph-devel@vger.kernel.org>; Fri, 25 Dec 2020 20:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=jRm5iqGs3h8vlBwY8QlD1PwukqBV3eVgOikBmaqngms=;
        b=ID9tKLzcRnLe1R8BYDQnGou2txs8dhS08k2RZpEpThO7l65ROSHIS6dmwHBullaZEr
         X9YLbMc/l3s9OMq0LNgFnRHHPyun+EZmIgX6CAWtEB0BSS2H0RLSMv/rUu33bchQcgC0
         6kCyFbN6gq+LIAMMqfx9zPF2wm6JeK+x3VOaQjgrG/7xS/k7n9HsE0gjTqDuwnqLt2JW
         IDkJiF1Y9acNzBdzVShS2zCEdAuLFqtJfQzRAc416KWbMGOnZuSQMd2s+efYxh+XdijE
         XIrZjAvLFWq1wiVdIPIcvjKT9jpdxlwuFSZxarXwmPvIFwwK3SvyoltjOmkVF5Q1mxrn
         DzCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=jRm5iqGs3h8vlBwY8QlD1PwukqBV3eVgOikBmaqngms=;
        b=de637KBomf3bGsAOyUE7RFKde6T7wkwc+6GMnttwnMiVdYwZ71T1o6guQ9e4fzcWsJ
         Ils/3b0bLJQv30DXi1M68p73xqNS99gIBhYSGPgZnHUSIZozxv1nbO2Pi2Xx9ldZvWqa
         0lZmdjf/ixRXqy/oH5tXE8l+QOM3dtgSHYUD5SWyu4+bDL/3hpRAzPtxRFs4xbVMDIQw
         pPuu8rnMtEdeT8NMzQ6SzoicuJ9QYeh3XWY2vvp+/P3AQOls5lXPbhQeIhZbEcXaHMmS
         COM1QQ4sHmYth4TGHiiX319pmetBn8NCCaPo8UdCby8kLadgVYhRQ+DBJ3w5/W8m7rL3
         0Rvg==
X-Gm-Message-State: AOAM533gzti3Tu48rnDRFse+qUliooKV8NqAII9IN4pZCMo6W6xJbf9x
        cvmoXfYEz+CKqLzsItfa7KBulNxJl3Ao1+964xL6XoZH
X-Google-Smtp-Source: ABdhPJyEhl0vSJIu1Yfr5etTILrjjckQbo6P0IsmjCw94nxv1JHNUwdCiuECi5lZYdiEVe+mhUpDyWeJ1qMDDGUPlAI=
X-Received: by 2002:a05:6e02:154c:: with SMTP id j12mr7407256ilu.33.1608958050406;
 Fri, 25 Dec 2020 20:47:30 -0800 (PST)
MIME-Version: 1.0
From:   Xiangyang Yu <penglaiyxy@gmail.com>
Date:   Sat, 26 Dec 2020 12:47:21 +0800
Message-ID: <CAE5T3Nz8k6bzsoZYWHYsr=SNBvVyjsvW5-sp=Rior-a2bbuUZA@mail.gmail.com>
Subject: [dmclock] reservation tag may be wrongly reduced
To:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi cephers,
I have read the dmclock paper  and now I am reviewing the dmclock code.

When  a request is popped by a proportion tag ., then the reservation
tag need to reduceed. In my opinion, we only need to reduce by 1/r
in mclock or dmclock. =EF=BC=88r is the  reservation inc =EF=BC=89

In the ceph dmclock code, I find that reduced num is max (1, tag.rho),
I think it's wrong .  Code is showed as follows:

// data_mtx should be held when called
void reduce_reservation_tags(ImmediateTagCalc imm, ClientRec& client,
const RequestTag& tag) {
double res_offset =3D
client.info->reservation_inv * std::max(uint32_t(1), tag.rho);
for (auto& r : client.requests) {
r.tag.reservation -=3D res_offset;
}
}

If i have missed some information, please tell me.
thanks .
