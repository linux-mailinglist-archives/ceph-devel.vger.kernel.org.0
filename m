Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB0FD141021
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jan 2020 18:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgAQRnC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Jan 2020 12:43:02 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:41716 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729148AbgAQRnC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 17 Jan 2020 12:43:02 -0500
Received: by mail-io1-f67.google.com with SMTP id m25so11284729ioo.8
        for <ceph-devel@vger.kernel.org>; Fri, 17 Jan 2020 09:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tYXCjg9orCedyvbaaJpC01HvKr/MiDbBI074e4U2DB8=;
        b=YM5EOsXAMb6rump4sZhAUfpvB7TtLtMTq+Hz901HHm99dFjAEIw/oDaygDAtwI+Aoq
         evHdXv/uxiU7dKy3t/AS2LQIVCAZnLKUFUUk5Yfbo2xxlDr2DX/eeuppr9W8VoVSzitk
         yib9EgV9Li6+QIkb9eBpQBVOZx57XEBKJLBOrEN3pOdoAJo30DiIeeqCmsG/QvHP+KKT
         cRbhrZfZtMnuy23Xv7p8qJBVBABPfjYYtSqV5KXpn+cPm4A2lk2EJwdASvJrI8vVreEW
         3Auf60kd2dJl/ziM00fPXgGJnZYAm8dU7In5+fIMwM6qpRLHwDIEBUii+Oqy8xQr++Fz
         D0bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tYXCjg9orCedyvbaaJpC01HvKr/MiDbBI074e4U2DB8=;
        b=q5m0+jiT5K7x14CSO+xoQYoIRvFgBnzHJILSqnlqhlKPvL87+kdJ1KJbqhTxmAed1v
         ctOKoySgGlKsvaRZKtbGKAlpXYDdJOLcGduzCxj/7KJ7Ejrp927eP+svIEdmTTilQd24
         3tRVtN5aV8/p3h5+Z+PcwojlQq8Zi3tXhMPnGbwCjmjxA7+LaOXEY05FcQuDkoyPvA80
         p7Drw/pYgXP4e6tLe30MhmN42syELls0PryURSlm50NXLRgZsnbpuo5h2YXRrjKtEDvr
         LlEwl9Vha1928vmMUWVi5nk8KGEtGCwILOXc1h3UxTExUAO1LqjJKCxUOU01PkwLZJW/
         E71w==
X-Gm-Message-State: APjAAAUS3YvPN3RgmjSe8AKnFBi4yDmwGtCMP60PQlDQCq1iJSEU5rsn
        Vg6brbo8CeWEAn1H2p6tmWSfXgOavwCyoblR5T40QSGQMYo=
X-Google-Smtp-Source: APXvYqz9qI4tBbbOC9rpWo9/NRC/98AzNYlqJW3+4P4NQl0RNF0Hmu4gqlU/M/7S9VkbFe2Q8T5607M1rIvttDsGw4g=
X-Received: by 2002:a6b:5917:: with SMTP id n23mr4148119iob.112.1579282981361;
 Fri, 17 Jan 2020 09:43:01 -0800 (PST)
MIME-Version: 1.0
References: <20200115205912.38688-1-jlayton@kernel.org> <20200115205912.38688-9-jlayton@kernel.org>
 <CAOi1vP_oXUTLfhMU6qWfk9Ha=09BdmwF52MeoytKHQWz+Mfwdw@mail.gmail.com> <374a760e8fae44e5cbdfd1bafa1f8f318e23770f.camel@kernel.org>
In-Reply-To: <374a760e8fae44e5cbdfd1bafa1f8f318e23770f.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 17 Jan 2020 18:42:59 +0100
Message-ID: <CAOi1vP96P89S2uMF81kuKgLcb7MDR-GGonr665S=rR87+Otsgw@mail.gmail.com>
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

On Fri, Jan 17, 2020 at 5:53 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2020-01-17 at 15:47 +0100, Ilya Dryomov wrote:
> > On Wed, Jan 15, 2020 at 9:59 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > Add new request field to hold the delegated inode number. Encode that
> > > into the message when it's set.
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/mds_client.c | 3 +--
> > >  fs/ceph/mds_client.h | 1 +
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index e49ca0533df1..b8070e8c4686 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -2466,7 +2466,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
> > >         head->op = cpu_to_le32(req->r_op);
> > >         head->caller_uid = cpu_to_le32(from_kuid(&init_user_ns, req->r_uid));
> > >         head->caller_gid = cpu_to_le32(from_kgid(&init_user_ns, req->r_gid));
> > > -       head->ino = 0;
> > > +       head->ino = cpu_to_le64(req->r_deleg_ino);
> > >         head->args = req->r_args;
> > >
> > >         ceph_encode_filepath(&p, end, ino1, path1);
> > > @@ -2627,7 +2627,6 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
> > >         rhead->flags = cpu_to_le32(flags);
> > >         rhead->num_fwd = req->r_num_fwd;
> > >         rhead->num_retry = req->r_attempts - 1;
> > > -       rhead->ino = 0;
> > >
> > >         dout(" r_parent = %p\n", req->r_parent);
> > >         return 0;
> > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > index 2a32afa15eb6..0811543ffd79 100644
> > > --- a/fs/ceph/mds_client.h
> > > +++ b/fs/ceph/mds_client.h
> > > @@ -308,6 +308,7 @@ struct ceph_mds_request {
> > >         int               r_num_fwd;    /* number of forward attempts */
> > >         int               r_resend_mds; /* mds to resend to next, if any*/
> > >         u32               r_sent_on_mseq; /* cap mseq request was sent at*/
> > > +       unsigned long     r_deleg_ino;
> >
> > u64, as head->ino is __le64?
> >
>
> Does that actually matter? It should get promoted to 64 bit when we do
> the encoding since we're passing by value, and this will never be larger
> than 32 bits on a 32 bit box.

It raises eyebrows -- one needs to remember that inode numbers
fit into unsigned long when looking at the code.  We are using u64
for inode numbers throughout ceph.ko: ceph_vino, ino parameters to
various functions, etc -- not just in the wire format definitions.
I think sticking to u64 is more clear and consistent.

Thanks,

                Ilya
