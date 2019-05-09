Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95B0B189F3
	for <lists+ceph-devel@lfdr.de>; Thu,  9 May 2019 14:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfEIMnN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 May 2019 08:43:13 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:38533 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfEIMnN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 May 2019 08:43:13 -0400
Received: by mail-lj1-f176.google.com with SMTP id 14so1885845ljj.5
        for <ceph-devel@vger.kernel.org>; Thu, 09 May 2019 05:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=GyJgk6QnrU0xR/DL/rSXjfwbUAddxPa/py1NLlo+W1Y=;
        b=iWErZh3u+cgi0IpZvZoFhBpDcjvx95ZF45wWlIxLox9Zpk/8Tyv2cPinIOkVTSzA3f
         7+8z6LAvkGXuPixUc3gPZYWx0MGUkzvMDKGBfQAqE5Ix2gggBxKbO4Vs6kzGZxs8k2YU
         +69cumuMqe4JTA4x9dFsB2/E4eCAMml9ERkIubh3+w5Njh6f1IR3qh29/iYKrEP+RdFC
         57EmOEAnB+3Iqvf3XWVy/Dwb4KrUVsHdFxLXZ9J8pMVVWX4RU7iZoEhI/VMlS0n33oTI
         9eHdQ//+dejo4DUKwTnlHDzvVUckfqlQgj7WR5XOF6THHSk3ZY+g8eIXSgzoX0OPb6O/
         2y7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=GyJgk6QnrU0xR/DL/rSXjfwbUAddxPa/py1NLlo+W1Y=;
        b=AVXX7Pcj44aNfbNjo+OIe2O1u8qVT81iK4+0AJn6iT8hTWuMTlKyacHOCdhGPxZ8r5
         zmLxbDcgZ54gxuxeDcKZlYVrnaiG6Jz4SdIO0rFkRh1UMYQXALJc4pQXqddkDqIoHr9K
         HMngueYSFBnd6rDHKiJrY8L/eyqaB4Zaa3YSGPDgpK17c7RSprdqLWy6UPSZn5Cu4pOH
         QNkBq3XhuKuDXPF6Sa/nrIuINK9q5sE4218iURxWe/g+AczfKa5pzP1xsId0boR/iEEY
         sUjMPmvmZIk3vOR3Mr+e4vcA7C9lSyjNNKAJBYy/HzSZcxbki3jPu29xZ+i37+XldwU1
         rKMA==
X-Gm-Message-State: APjAAAVMa/o6QcosimaeBi7ytseaLpChzAiPJ8zUJA3UBQGjiwG5toR8
        /5a9wMvwXXeTsmKhlKlOI6tHuKgJwjHBcVUkg8j3+vcHOeSS9A==
X-Google-Smtp-Source: APXvYqyvsIunzUeo83zWYmU/GOmqKPrfgdP25wsRfd2MbzhZQbJiad23nLjb23plYcP66rkm7Uu/l3VuK57QrojkRkM=
X-Received: by 2002:a2e:3a17:: with SMTP id h23mr2373858lja.105.1557405790932;
 Thu, 09 May 2019 05:43:10 -0700 (PDT)
MIME-Version: 1.0
From:   Ugis <ugis22@gmail.com>
Date:   Thu, 9 May 2019 15:42:59 +0300
Message-ID: <CAE63xUOEcQhUnys1Phq-3-+BmN-C7gSd9pHv6vRGy1MW1=TnKQ@mail.gmail.com>
Subject: Ceph iscsi targets on ubuntu
To:     Ceph Development <ceph-devel@vger.kernel.org>, florian@florensa.me
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

Going for new ceph cluster, wishing to deploy iscsi gateways from the beginning.

Reviewed docs, there still is no sign that iscsi gateways are
available on Ubuntu
http://docs.ceph.com/docs/master/rbd/iscsi-targets/

Is this still true or there are descriptions how to setup iscsi
targets on ubuntu somewhere outside official docs? Of course, this
should flawlessly integrate with Nautilus dashboard.

Best regards
Ugis
