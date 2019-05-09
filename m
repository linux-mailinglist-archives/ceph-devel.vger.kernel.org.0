Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFDDA1836C
	for <lists+ceph-devel@lfdr.de>; Thu,  9 May 2019 03:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfEIB6H (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 May 2019 21:58:07 -0400
Received: from mail-lj1-f169.google.com ([209.85.208.169]:45805 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfEIB6G (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 May 2019 21:58:06 -0400
Received: by mail-lj1-f169.google.com with SMTP id r76so549753lja.12
        for <ceph-devel@vger.kernel.org>; Wed, 08 May 2019 18:58:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2csDHUwsfZ9vKiM6L0X2VwRtlMfkReR7eWIJEs97n9I=;
        b=bkd9wd3UWWnxxpLDBv3yBm5g3o9EjyIaMbSSBZvePKdiJiQfa6LyFyWNKGh4gZ1RfD
         M20pMxf1fePxaKuKbfAeidBC5PsUM0teVuxWmj14LnfgvGEkpuaNfZ3ni1ms3rCQQNql
         /3dFL4wjMpi71AescnyIgxEbnUm1N4FOFwH6G0CJNuHsgOWr9FakSZBgT+k1O8bLdBZM
         4MYJxMvzv/GgRHh9ufqjffNVqIAWhIxdZ9JGiiNVr06E/0UzPDPNMUe8JC6dqAGyI5o7
         4mgNDqvovUIObdYfP5i37VDB9a6EMSFB6SEjn6JZuCYZkZy/knivoRLUhUPQxb+yVqK/
         GUtQ==
X-Gm-Message-State: APjAAAV6zEQ55Z1SUYFYDvY/bZvk0dX4rV/m8JmR0wcTgS+jVb6NcONV
        Q33ID/0dqrcdsEsq4vvknN7RZWA3qIUAYwMUWaFGR7blrZY=
X-Google-Smtp-Source: APXvYqylj14L39MnHAhEsIIlN2EPisoqhJSlp9mSUQvUD6OUW77UPur08v0v/A40Swah9TggJrL2lsn/d2nf1Or8oA4=
X-Received: by 2002:a2e:7f12:: with SMTP id a18mr543619ljd.144.1557367084587;
 Wed, 08 May 2019 18:58:04 -0700 (PDT)
MIME-Version: 1.0
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Thu, 9 May 2019 11:57:53 +1000
Message-ID: <CAF-wwdHUGhQHva9uOt8dL=Mh-GHmvo3xrOP4XB1o8RU7mUDMgw@mail.gmail.com>
Subject: Static Analysis
To:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Latest static analyser results are up on  http://people.redhat.com/bhubbard/

Weekly Fedora Copr builds are at
https://copr.fedorainfracloud.org/coprs/badone/ceph-weeklies/

-- 
Cheers,
Brad
