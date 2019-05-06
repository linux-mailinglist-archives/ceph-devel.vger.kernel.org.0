Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D08B014A2B
	for <lists+ceph-devel@lfdr.de>; Mon,  6 May 2019 14:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfEFMsM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 May 2019 08:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfEFMsL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 6 May 2019 08:48:11 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B5FD20830;
        Mon,  6 May 2019 12:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557146890;
        bh=5TfySQxugl5OZlF9S3r7QDz/Sdd7Jwxo80VKF6CBZXw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hx8zV4Y4LlX5kHhoQY6UKBUWFlBs1KUA2txFCw0cD6caivUJRc7GH03aFlShR4QVp
         2eddiAQ5iqM2SNvPvlY67x3hxmBz3nS5oB/e/fv5V3Yy2opHBIpzM8/nbmQ24JigIp
         kfXDyMMpTA7YZyQab6g2oZ3L9JjpU95DQ805OTyo=
Message-ID: <36691ddf47c8d18825759e721666560a86ebf98c.camel@kernel.org>
Subject: Re: [PATCH v2 1/3] libceph: fix unaligned accesses in
 ceph_entity_addr handling
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Mon, 06 May 2019 08:48:08 -0400
In-Reply-To: <CAOi1vP9JPn6B8Ss8TPOPVND=D=YOYHmd15ghfYvhe4dxX9TZ_g@mail.gmail.com>
References: <20190502184638.3614-1-jlayton@kernel.org>
         <CAOi1vP9JPn6B8Ss8TPOPVND=D=YOYHmd15ghfYvhe4dxX9TZ_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1 (3.32.1-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-05-06 at 12:32 +0200, Ilya Dryomov wrote:
> On Thu, May 2, 2019 at 8:46 PM Jeff Layton <jlayton@kernel.org> wrote:
> > GCC9 is throwing a lot of warnings about unaligned access. This patch
> > fixes some of them by changing most of the sockaddr handling functions
> > to take a pointer to struct ceph_entity_addr instead of struct
> > sockaddr_storage.  The lower functions can then take copies or do
> > unaligned accesses as needed.
> 
> Linus has disabled this warning in 5.1 [1], but these look real to me,
> at least when sockaddr_storage is coming from ceph_entity_inst.  I'd be
> happier if we defined non-packed variants of ceph_entity_addr and
> ceph_entity_inst and used them throughout the code, but that's likely
> a lot more churn.  I might take a stab at it just to see how it goes...
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6f303d60534c46aa1a239f29c321f95c83dda748
> 

Yeah, they looked like legit problems to me too. I too was going to move
them over to use a non-packed representation internally, but it did turn
out to be quite a bit of churn and copying. YMMV of course.

> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  net/ceph/messenger.c | 77 ++++++++++++++++++++++----------------------
> >  1 file changed, 38 insertions(+), 39 deletions(-)
> > 
> > diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> > index 3083988ce729..54713836cac3 100644
> > --- a/net/ceph/messenger.c
> > +++ b/net/ceph/messenger.c
> > @@ -449,7 +449,7 @@ static void set_sock_callbacks(struct socket *sock,
> >   */
> >  static int ceph_tcp_connect(struct ceph_connection *con)
> >  {
> > -       struct sockaddr_storage *paddr = &con->peer_addr.in_addr;
> > +       struct sockaddr_storage addr = con->peer_addr.in_addr;
> 
> Probably worth a comment, even something as short as /* align */.
> 

Sounds good. I'll add those to the ones below too.

> >         struct socket *sock;
> >         unsigned int noio_flag;
> >         int ret;
> > @@ -458,7 +458,7 @@ static int ceph_tcp_connect(struct ceph_connection *con)
> > 
> >         /* sock_create_kern() allocates with GFP_KERNEL */
> >         noio_flag = memalloc_noio_save();
> > -       ret = sock_create_kern(read_pnet(&con->msgr->net), paddr->ss_family,
> > +       ret = sock_create_kern(read_pnet(&con->msgr->net), addr.ss_family,
> >                                SOCK_STREAM, IPPROTO_TCP, &sock);
> >         memalloc_noio_restore(noio_flag);
> >         if (ret)
> > @@ -474,7 +474,7 @@ static int ceph_tcp_connect(struct ceph_connection *con)
> >         dout("connect %s\n", ceph_pr_addr(&con->peer_addr.in_addr));
> > 
> >         con_sock_state_connecting(con);
> > -       ret = sock->ops->connect(sock, (struct sockaddr *)paddr, sizeof(*paddr),
> > +       ret = sock->ops->connect(sock, (struct sockaddr *)&addr, sizeof(addr),
> >                                  O_NONBLOCK);
> >         if (ret == -EINPROGRESS) {
> >                 dout("connect %s EINPROGRESS sk_state = %u\n",
> > @@ -1795,12 +1795,13 @@ static int verify_hello(struct ceph_connection *con)
> >         return 0;
> >  }
> > 
> > -static bool addr_is_blank(struct sockaddr_storage *ss)
> > +static bool addr_is_blank(struct ceph_entity_addr *ea)
> >  {
> > -       struct in_addr *addr = &((struct sockaddr_in *)ss)->sin_addr;
> > -       struct in6_addr *addr6 = &((struct sockaddr_in6 *)ss)->sin6_addr;
> > +       struct sockaddr_storage ss = ea->in_addr;
> 
> Same here.
> 
> > +       struct in_addr *addr = &((struct sockaddr_in *)&ss)->sin_addr;
> > +       struct in6_addr *addr6 = &((struct sockaddr_in6 *)&ss)->sin6_addr;
> > 
> > -       switch (ss->ss_family) {
> > +       switch (ss.ss_family) {
> >         case AF_INET:
> >                 return addr->s_addr == htonl(INADDR_ANY);
> >         case AF_INET6:
> > @@ -1810,25 +1811,27 @@ static bool addr_is_blank(struct sockaddr_storage *ss)
> >         }
> >  }
> > 
> > -static int addr_port(struct sockaddr_storage *ss)
> > +static int addr_port(struct ceph_entity_addr *ea)
> >  {
> > -       switch (ss->ss_family) {
> > +       struct sockaddr_storage ss = ea->in_addr;
> > +
> > +       switch (ss.ss_family) {
> >         case AF_INET:
> > -               return ntohs(((struct sockaddr_in *)ss)->sin_port);
> > +               return ntohs(((struct sockaddr_in *)&ss)->sin_port);
> >         case AF_INET6:
> > -               return ntohs(((struct sockaddr_in6 *)ss)->sin6_port);
> > +               return ntohs(((struct sockaddr_in6 *)&ss)->sin6_port);
> >         }
> >         return 0;
> >  }
> 
> Can we do the get_unaligned() dance instead of copying here?
> 

I tried that a couple of different ways last week, but we have to take a
pointer to the sockaddr_storage in order to cast to it to a
sockaddr_in{6}. Maybe I'm missing something though, so let me know if
you see a better way to do this.

That said, we only call this from process_banner(), so I don't think the
copying is likely to harm performance.
-- 
Jeff Layton <jlayton@kernel.org>

