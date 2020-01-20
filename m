Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7BCB14277B
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Jan 2020 10:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgATJl2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 20 Jan 2020 04:41:28 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:46448 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgATJl1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 20 Jan 2020 04:41:27 -0500
Received: by mail-il1-f195.google.com with SMTP id t17so26700138ilm.13
        for <ceph-devel@vger.kernel.org>; Mon, 20 Jan 2020 01:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C//iDAlmupGuVDPg5XIBE4LA0sN2xJd8n3MC+eZ3EYk=;
        b=PdWpQkhdxAa/qdmTZE0233AfZ6ZJLRD6IrQBZgmYsMD/9lju4xBdIwubZ+xns/GUfv
         Cyc1iqvIFrKbPNjT66xeeKL+qoHkur+gi89TWpMfe3VaFbVYUvhM+TePuxEDXi970xEh
         WSt8kIZUaW/okTE4dQAZuKnBw5tJB264A1ID2p+geaXWcXyfmM8deASfLZQYniDHvyRK
         yh2xHW8S5HV1XNrNobcBxWr/e2CV17koIOicNcQMhgeekiyTx4SnnGpekHwb+13bTA9L
         8QBP/Q4Maz7aT3xQbmVMiDf7skOqZaR/FAKnjRAV2Pjj1jSYMeVt8ghwgHHMk2NQjjUU
         bzfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C//iDAlmupGuVDPg5XIBE4LA0sN2xJd8n3MC+eZ3EYk=;
        b=YRHbJQb6nTpXv3YUB+mH1EY63uabfqWst4ORI8wd1pYOTKwwDTwrGKkweylkZ+HGvX
         EgM+8aP8wtlKe+a/f/E2Fn5QKmB+6LL+93J9GK6OHEwe9WwzZM9Ko4YxeupME7nDejXQ
         QT03LOX2ppnF+tuFIV8oQBVT32c8mc5sQCQmXFRwya8dUfcQZs87rWmC61oEEx2jlnsN
         0ZFYZweSgodtod4ia06oS3B8bsy1eJbz49L7MmdEdpP9GIKdSoHhKuLRkRCX/Zu1+J6P
         4M4VQwRmH/sqQYCItwvOeMl6WCGTTPvvobeLLhuiiNjBaKk2vsHCyNmmWE9OPbRppCJn
         eYGQ==
X-Gm-Message-State: APjAAAWi6NJiogPosAhpjia+jSknedKhlpQ1/AggYHwZLfby+LKMhc/D
        fw6FpqWZ0pWvo7m4lZtxqDSQzvnZMbQW/eBXgHOmFzdqll4=
X-Google-Smtp-Source: APXvYqx9N3nL5p8vtczdmEPymxBV/+tFcvo3Z7qSB0B06bMhzeEYO+OxcYNH3LD2wO/bKy5wNywtD72KUTknItYqXo4=
X-Received: by 2002:a92:d7c6:: with SMTP id g6mr9821059ilq.282.1579513287127;
 Mon, 20 Jan 2020 01:41:27 -0800 (PST)
MIME-Version: 1.0
References: <20200115205912.38688-1-jlayton@kernel.org> <20200115205912.38688-9-jlayton@kernel.org>
 <CAOi1vP_oXUTLfhMU6qWfk9Ha=09BdmwF52MeoytKHQWz+Mfwdw@mail.gmail.com>
 <374a760e8fae44e5cbdfd1bafa1f8f318e23770f.camel@kernel.org>
 <CAOi1vP96P89S2uMF81kuKgLcb7MDR-GGonr665S=rR87+Otsgw@mail.gmail.com> <c170d5d3ccec27a2c6a4ec1a7dd8265746356acf.camel@kernel.org>
In-Reply-To: <c170d5d3ccec27a2c6a4ec1a7dd8265746356acf.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 20 Jan 2020 10:41:28 +0100
Message-ID: <CAOi1vP-RMTRdxw96q6KjfFYS3zec-fD0GwKiQO1Hw-4MFJ6vFA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 08/10] ceph: add new MDS req field to hold
 delegated inode number
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jan 17, 2020 at 7:31 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2020-01-17 at 18:42 +0100, Ilya Dryomov wrote:
> > On Fri, Jan 17, 2020 at 5:53 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > On Fri, 2020-01-17 at 15:47 +0100, Ilya Dryomov wrote:
> > > > On Wed, Jan 15, 2020 at 9:59 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > Add new request field to hold the delegated inode number. Encode that
> > > > > into the message when it's set.
> > > > >
> > > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > > ---
> > > > >  fs/ceph/mds_client.c | 3 +--
> > > > >  fs/ceph/mds_client.h | 1 +
> > > > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > > index e49ca0533df1..b8070e8c4686 100644
> > > > > --- a/fs/ceph/mds_client.c
> > > > > +++ b/fs/ceph/mds_client.c
> > > > > @@ -2466,7 +2466,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
> > > > >         head->op = cpu_to_le32(req->r_op);
> > > > >         head->caller_uid = cpu_to_le32(from_kuid(&init_user_ns, req->r_uid));
> > > > >         head->caller_gid = cpu_to_le32(from_kgid(&init_user_ns, req->r_gid));
> > > > > -       head->ino = 0;
> > > > > +       head->ino = cpu_to_le64(req->r_deleg_ino);
> > > > >         head->args = req->r_args;
> > > > >
> > > > >         ceph_encode_filepath(&p, end, ino1, path1);
> > > > > @@ -2627,7 +2627,6 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
> > > > >         rhead->flags = cpu_to_le32(flags);
> > > > >         rhead->num_fwd = req->r_num_fwd;
> > > > >         rhead->num_retry = req->r_attempts - 1;
> > > > > -       rhead->ino = 0;
> > > > >
> > > > >         dout(" r_parent = %p\n", req->r_parent);
> > > > >         return 0;
> > > > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > > > index 2a32afa15eb6..0811543ffd79 100644
> > > > > --- a/fs/ceph/mds_client.h
> > > > > +++ b/fs/ceph/mds_client.h
> > > > > @@ -308,6 +308,7 @@ struct ceph_mds_request {
> > > > >         int               r_num_fwd;    /* number of forward attempts */
> > > > >         int               r_resend_mds; /* mds to resend to next, if any*/
> > > > >         u32               r_sent_on_mseq; /* cap mseq request was sent at*/
> > > > > +       unsigned long     r_deleg_ino;
> > > >
> > > > u64, as head->ino is __le64?
> > > >
> > >
> > > Does that actually matter? It should get promoted to 64 bit when we do
> > > the encoding since we're passing by value, and this will never be larger
> > > than 32 bits on a 32 bit box.
> >
> > It raises eyebrows -- one needs to remember that inode numbers
> > fit into unsigned long when looking at the code.  We are using u64
> > for inode numbers throughout ceph.ko: ceph_vino, ino parameters to
> > various functions, etc -- not just in the wire format definitions.
> > I think sticking to u64 is more clear and consistent.
> >
>
> Yeah, now that I think about it, you're right. This is going to be a
> inode presented to the MDS, so it will always need to be 64-bit. Fixed
> in my tree.

Other patches in this set introduce function parameters and local
variables that are unsigned long and used for inode numbers.  I think
they need to be fixed up as well.

Thanks,

                Ilya
