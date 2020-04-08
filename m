Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB1B51A1A34
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Apr 2020 05:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgDHDKr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Apr 2020 23:10:47 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37057 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbgDHDKr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Apr 2020 23:10:47 -0400
Received: by mail-qk1-f195.google.com with SMTP id 130so1786611qke.4;
        Tue, 07 Apr 2020 20:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R41HqWjcCbxYDiIRtOcIY5SZNzrEIQi9LSpnnC9HzOA=;
        b=MbffZqs5HMwMl9Beq2oGUb2EGJrN+vUBK+nJ9tUZLE6weH0OE/Fja8XC2yAJQTYodQ
         WC7nj+bifOC0nNwPvyoAYa6AJ2agDyaRr3ton2Ejla4KVt40HbQi4naKbcr8eNDnIxJV
         Gdo9wVM+NQO6TDvfHJLsbW2ab6lj+UoirauNIOnFpAKuTSHH2oOqC5GtS+oQ2S2SuXgr
         HzTtqhM3AgBIKirvgSq2oocFB8PifEOFTWelWak0sy4PxkcMJAhAXVWQee2EE9kIQEj5
         AK0n4DVEZGrHhhPCpy4KT0732QpGBE28HG/Othh0nTnDdVVk9dqHyB/vsz1DzIJFs3+g
         EDWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R41HqWjcCbxYDiIRtOcIY5SZNzrEIQi9LSpnnC9HzOA=;
        b=P3WFHpZN9/z6Ggj/mY9PhST9g4oxEyAi+FDAnHZNonFIWSS58+HS0503Uzm05gSDOY
         Ng8IqO5ueCqJn7PKdvD5pFMUXuszao0amG42vjRSc0imc9eTHYzJOGGNXsLW94Vsl5HQ
         PeSRMBEwGBZ5p6gpPci3tJT7Gz8/aMsxPVIQ4ztFEi40Jm5jqS9y9WgiyNEbGddJOUwp
         3jFVGqL+jZpi+qDQ285Hn5Qt6nzniLlGOZh3kG2QBh4hWNn8PoLaPIKHP3AB0jo4vjyu
         1JyhA1HSSyV3GV+xlEIVutdbTq6t7OQxTvjufetPgXjVYGWOpaySUzHMvb8BDCOA+JN7
         UrRg==
X-Gm-Message-State: AGi0PubrbxCNm1qDsklsNgIqZJNpyp6+zJc5SiPHaWwhn4+wBgg43ndY
        kEu/74Un5KOutpQFrnUlGkxaaX52zvMfcnoLHig=
X-Google-Smtp-Source: APiQypIs/DofL/e/K34XwS0je2W1gC36aclLgh8V94q8AO7e/ckZ527xDMiAROJrk6oXj8M9fi7NWQaXlwQ8qMdY3G8=
X-Received: by 2002:a37:8707:: with SMTP id j7mr5615646qkd.394.1586315445954;
 Tue, 07 Apr 2020 20:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200407103020.22588-1-lhenriques@suse.com> <20200407103020.22588-3-lhenriques@suse.com>
 <e32db4ef5a0ae4e2002a3d957491c88e49daa5bb.camel@kernel.org>
In-Reply-To: <e32db4ef5a0ae4e2002a3d957491c88e49daa5bb.camel@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 8 Apr 2020 11:10:34 +0800
Message-ID: <CAAM7YAmpDKu_WuroNxZ2y+Po8_oT59Bi4_FOY1LD1ttOO0UDgQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] ceph: allow rename operation under different quota realms
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Zheng Yan <zyan@redhat.com>, Frank Schilder <frans@dtu.dk>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Apr 8, 2020 at 7:00 AM Jeff Layton <jlayton@kernel.org> wrote:

>
> Somewhat idle curiosity, but what happens with hardlinked files where
> one dentry is in one quota domain and another is in a different one?
> Does it stay in the old quotarealm?
>
> In any case, this is likely fine as non-hardlinked files are the
> pessimal case anyway.

rstat only tracks primary dentry.  inode is in the quota realm where
its primary linkage is in.
