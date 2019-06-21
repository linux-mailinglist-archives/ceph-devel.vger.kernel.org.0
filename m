Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5A64EA9E
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Jun 2019 16:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbfFUOaq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Jun 2019 10:30:46 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37803 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfFUOap (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 21 Jun 2019 10:30:45 -0400
Received: by mail-ot1-f65.google.com with SMTP id s20so6510120otp.4
        for <ceph-devel@vger.kernel.org>; Fri, 21 Jun 2019 07:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cic1xXg1Zsa9ZT/6O0fIxPbZ+6LB3btGevHVvR5edf8=;
        b=BrlpUuitkknzkUXsF8OzWVVqweUZ7IZJoqsST+z+dp7j9FV4fCfJEmXw0iDpvEWRxG
         +mHmWP7mpTD98G+ByZrT86pvGGq1GBEF87C7pLMkl40u2oNUpzVpcTCTABR3N1i7vEsT
         s44QenaEs1/IJAp/KlMQizXjpfBr044G3y6CIGZ2KodiJ6X8UD/OWCgOQ2Q9XnhKxVQ7
         Mt3LuEte5NxRhiwxlBb7rCRIUwxGY5byPGRGdnCsuLvChk6/WamRaXLF79e8z759OcFe
         q0UbGtGYaUtQ9K91usOJQ5d4ZXELK4qnZWQcUgkVakAevEoE/Tgi6zNwTWWyV9Lgbmxh
         4U3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cic1xXg1Zsa9ZT/6O0fIxPbZ+6LB3btGevHVvR5edf8=;
        b=EAZnon83BHIILdx32Hh075Ab0VzF6SRfIpdiZRLYVCoE5WHPXdCnpf/+0s2cQgC3fW
         WBjn5bpRnr14sOC681vEkt8Nc6Zyl6vWiE3B/4EtCltC45n0g1ZcX2dIVSDzpDi5GGSY
         JmYLIEwGRfdtvkKOe7SIvGvYzj7+KkuapSlbMVNfPdiX9AttlDSb6FYhL1kZWv5GAi6S
         5K9RT47OS/fIWeuHRfcd8C8txwUFG2qwhRFs5bKw9zvwUV8Q5iKiCeCEDZRf6MBBeQwx
         QKMU1GsR0IeLkUHnTLmwVh2vNihHHewQDm4Z10KGU+/nS5vr1SnTTZ8ZQtWsOY1PhVe+
         1sEQ==
X-Gm-Message-State: APjAAAVaBslflG+qc2TKJeINQ/SZv4gu2xmP479usE+SoKoV/+vXCENC
        YuX3L4kR4ZtBw9HTyUCWWE6bHBlqLhOQ/ZmcR7VvGzTM
X-Google-Smtp-Source: APXvYqxhqYpi2U8lkBonmo2g2FqfrXzlPlZDc6PDdudxGUn55GltP1na7IcV5op13vUjW4gzQClI/5Ky4Rp+PJAoADw=
X-Received: by 2002:a9d:4109:: with SMTP id o9mr8649420ote.353.1561127445113;
 Fri, 21 Jun 2019 07:30:45 -0700 (PDT)
MIME-Version: 1.0
References: <CABAwU-Zv1d1qT5n2-JEcm1vpK9XdTg30yzrhMoeQ2B4ujO=peA@mail.gmail.com>
In-Reply-To: <CABAwU-Zv1d1qT5n2-JEcm1vpK9XdTg30yzrhMoeQ2B4ujO=peA@mail.gmail.com>
From:   kefu chai <tchaikov@gmail.com>
Date:   Fri, 21 Jun 2019 22:30:33 +0800
Message-ID: <CAJE9aONkU7L7wAZheQyZQ6kbaZ8C-jtCGB+qY6_rrmiuDijHzQ@mail.gmail.com>
Subject: Re: ceph-monstore-tool rebuild question
To:     huang jun <hjwsm1989@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 13, 2019 at 10:06 AM huang jun <hjwsm1989@gmail.com> wrote:
>
> Hi,all

Jun, sorry for the latency. got stuck by something else. =(

> I recently read the ceph-monstore-tool code, and have a question about
> rebuild operations.
> In update_paxos() we read  osdmap, pgmap, auth and pgmap_pg records to
> pending_proposal(a bufferlist) as the value of  the key paxos_1, and
> set paxos_pending_v=1,
> and set the paxos_last_committed=0 and paxos_first_committed=0;
>
> My question is if we start the mon after rebuild, let's say there is
> only one mon now, the mon will not commit the paxos_pending_v=1, and
> if we change the osdmap by 'ceph osd set noout' the new pending_v=1
> will overwrite the former one in rebuild, so i think we don't need to

agreed, unless the initial monmap requires more monitors. it will
prevent the monitor from forming a quorum to write to the store. yeah,
the paxos/1 will be overwritten by the first proposal at rebuilding
the mondb. but i think we still need to store the "rebuild"
transaction as a paxos proposal, as we need to apply the transaction
on the sync client side, after the it syncs the chunks with the sync
provider.

probably we should just bump up the last_committed to a non-zero
number, to preserve the rebuild transaction. actually, i was testing
the fix of the issue you are talking about using the PR of
https://github.com/ceph/ceph/pull/27465. but i didn't get a chance to
look into the reason why it still failed..

> set paxos_1=pending_proposal, paxos_pending_v=1 in 'ceph-monstore-tool
> rebuild'.
>
> Thanks!
> _______________________________________________
> Dev mailing list -- dev@ceph.io
> To unsubscribe send an email to dev-leave@ceph.io



--
Regards
Kefu Chai
