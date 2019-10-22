Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63C9DFDD8
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Oct 2019 08:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387814AbfJVGxK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Oct 2019 02:53:10 -0400
Received: from mail-oi1-f172.google.com ([209.85.167.172]:39817 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387800AbfJVGxJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 22 Oct 2019 02:53:09 -0400
Received: by mail-oi1-f172.google.com with SMTP id w144so13271532oia.6
        for <ceph-devel@vger.kernel.org>; Mon, 21 Oct 2019 23:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=p/GubyBFFruqWlpxvskRvc88KatsnK23ZH8EIeF+0RQ=;
        b=uNkCwwuXvo42Aglr5W7SGVdms+chsU2iYrqITSxd/O346KloDBhpc+e02ofScTdGV8
         hzIfjaQGxJApgy5xcZuqsycAF6Jk2hLI329xzyYCjZdvO1efgVE/GEHhO+0ByaF0pMla
         2pjC0YTpaDdIELOyrQZWF/BbycFiEqp4MVMHMlxMLCtzuKfQnWTzH0RhVKwUFTQPi/6m
         Xpz0mhC13uBjB0583VGKnEyx1qSpyuMgRScj5Z63NEUwl1u7O/PFD34Zx6gZzd/DTG/o
         i+VcdnUNncfSEgJ4k7X5c12LUp2kYsLEcmJ7tFn0SYy04JEvTsXNkXFaDq9oobcwlDJN
         4/ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=p/GubyBFFruqWlpxvskRvc88KatsnK23ZH8EIeF+0RQ=;
        b=m+fR0v55JikL5mJ7TTLeEuYsYX9LUjx8k1aTAuPeQCY3Dpce5PhsZAdU2huObDWHbm
         4DoF+uHBDRtsxehi4i87lcC3CUbNFA9RglBt9CdTocQlzzJjuvEDh01E8dNmuBzBqQNe
         0J6NS3ldVtlXrOJqLnrBtq8cSDH+R6aDvTDkk48BJPBmpqdg2zTx6h7Bt/sGgV0z0nB3
         bHD4Z+lPpd0M615+9Jsl+n28lnrUKZt0f79vtxjxHIa3O4PvsZB2esupTdV/oOPIsEOd
         eXeZ/lqfTsLcLUlFMBmvQx+TxAnXee1edskcUHtW6yWaxIcyB1kdHgbla5VbW3SqTIda
         bhCg==
X-Gm-Message-State: APjAAAXKkuWRwki2W+kMZAU/l1MPqV91PLo38wYqzZKkAEYdTTy1TLDZ
        0b+gsEWFc87rJTFPmnKpDytIUW97hp3QXUHVtmFjPw==
X-Google-Smtp-Source: APXvYqyyKGA3GFktXaE/vmhoDcD7xH49e0QmphkgeCKSKXSDhsKlX8az/TLW+1AGrD4WfIqGx7BdhvlMb4nQTlupOIQ=
X-Received: by 2002:a05:6808:3bc:: with SMTP id n28mr1591331oie.67.1571727188600;
 Mon, 21 Oct 2019 23:53:08 -0700 (PDT)
MIME-Version: 1.0
From:   Xuehan Xu <xxhdx1985126@gmail.com>
Date:   Tue, 22 Oct 2019 14:52:44 +0800
Message-ID: <CAJACTufVvn_sMRYi8uM-RSmeD8R0Knjvqy2pNH5CEDO4hLD5gQ@mail.gmail.com>
Subject: Why choose seastar over spdk event framework?
To:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi, everyone.

It seems that spdk's event framework also provide a similar high
performance application framework, why the community choose seastar
over spdk event framework? Thanks.
