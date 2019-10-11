Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCC28D44EF
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Oct 2019 18:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbfJKQEl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Oct 2019 12:04:41 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:35826 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727231AbfJKQEl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Oct 2019 12:04:41 -0400
Received: by mail-io1-f50.google.com with SMTP id q10so22694954iop.2
        for <ceph-devel@vger.kernel.org>; Fri, 11 Oct 2019 09:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=vJgR3vuUqtGTR8A1XozqEij5GiG0EU8kQwRAJ9vXzn0=;
        b=UToQOLnzu/wikpR3fkLD4XLw3efZziUE+MSEUZKpd6NYcqzKcwB1fsxVXUz+Hn0tkw
         GibASVdqeGp9zH2WgRzpMnUxXNv/1l8zD4lSGuY335uf21vto06eRQ1yfDU+RnRk4cri
         Ssx5uuEtZWrIMZm1RuSAI9NBxDp6zzx83NtCcTQdsyDYLEOSMVXJIUjn7JzDgZEtUaUS
         fdMRNGb2tZo0oBY5/HZCJHs8ZKP2lXdAaK1mFJkT2L3C2TT+AKvhO5cNf9ZHkzua6eXC
         9bzNPw7I6ndrHSQHAPxYKsHiBySsPnmzQumzwnDVPxLAsZe+KE1mxK92rcUslI31I9Eu
         bbgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=vJgR3vuUqtGTR8A1XozqEij5GiG0EU8kQwRAJ9vXzn0=;
        b=XMG6q2yYR2rI9sJbpcTsfAfGRRZFKjzMLeQdZsmG3sYUZz/Mm+hiG3gbqScsxQnEfm
         LyLlpdCIFbozZCRrsDk432od+1VXyRm4htFnEXcf5GibMRh5KWD5/wkl3xqobIAhsbUp
         U1+29BuwTrrQQYFUFGPZOTMGmdCWySU/Y3MjtOd3gktj46UDeE6NKPaqcQIBjYT1LD64
         vTUVPQjAYbwUmQ73+pDRzBajWHc8PXXbWT+F2jY8KPuOTIELIr94d+b1LoSkz23tafjT
         aiiFY7dy7eo0IFGw9vdFKOFvVxHvuopPtLQ4JjLgBzxGNbtqAZJj/Thw/T2fJHnMNxeL
         lJRA==
X-Gm-Message-State: APjAAAWPtrd9eEgslToLy7K9P2l4wDn9aGv4MkAkN+DGb7iQTNwfGKpD
        R4oE7avRpzx8OFK0/V9R6ZPuJJKAVNkzSILBlSYarPvC
X-Google-Smtp-Source: APXvYqwYcYo2t1ofko6w+2nYEvExpZVRX6hNsd01pxqJnTnfuXo7mRooMc0zoKo236mKiol7c0YQ13hdWlg9mkjSjlA=
X-Received: by 2002:a5d:884f:: with SMTP id t15mr485895ios.224.1570809880707;
 Fri, 11 Oct 2019 09:04:40 -0700 (PDT)
MIME-Version: 1.0
From:   "Honggang(Joseph) Yang" <eagle.rtlinux@gmail.com>
Date:   Sat, 12 Oct 2019 00:04:29 +0800
Message-ID: <CAMrPN_JjckOAnQC_=C+YJ1+QTMRbUkGSu24Pyuo1EC=rfXGuRQ@mail.gmail.com>
Subject: local mode -- a new tier mode
To:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

We implemented a new cache tier mode - local mode. In this mode, an
osd is configured to manage two data devices, one is fast device, one
is slow device. Hot objects are promoted from slow device to fast
device, and demoted from fast device to slow device when they become
cold.

The introduction of tier local mode in detail is
https://tracker.ceph.com/issues/42286

tier local mode: https://github.com/yanghonggang/ceph/commits/wip-tier-new

This work is based on ceph v12.2.5. I'm glad to port it to master
branch if needed.

Any advice and suggestions will be greatly appreciated.

thx,

Yang Honggang
