Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A483B59B826
	for <lists+ceph-devel@lfdr.de>; Mon, 22 Aug 2022 05:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbiHVDxg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 21 Aug 2022 23:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbiHVDxf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 21 Aug 2022 23:53:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C528ECE00
        for <ceph-devel@vger.kernel.org>; Sun, 21 Aug 2022 20:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661140411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SNIkMYCx44TegSS1gpQdE2bwiprNXsF1VjqMbT7/05w=;
        b=WWWNGQaMnBiTaU06a5Ko4uTDnqIAhgZYhvnQ71fSSrBU2KTV3tfLckFb4CzKDRSJWmyIAT
        wtsJcy01pnzFJWGxgOgkIelPjX3QnU+9nHEXw75p73H3tTU9N9ueTr5z37vnmx0x2RnWMs
        MS8B4VhrRqScvO4qsy6tDDHfqrwYaB0=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-107-hwpsJmYeMhubPiuA4fHYKQ-1; Sun, 21 Aug 2022 23:53:30 -0400
X-MC-Unique: hwpsJmYeMhubPiuA4fHYKQ-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-3345ad926f2so168298557b3.12
        for <ceph-devel@vger.kernel.org>; Sun, 21 Aug 2022 20:53:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=SNIkMYCx44TegSS1gpQdE2bwiprNXsF1VjqMbT7/05w=;
        b=pKR2Mc9If4H91kHJB9ZjvsCwNbwKPDERo63IOwxt298RK2c4caLTDbzJlsckWScEHd
         mVCGEa2UIZ3NQMJLUFVuaCwMXyeH32KlV36z213dvkenGG2DL39p0Ch6qXtA7KKfspFl
         5yATEcfPdS+g+x9Wm4hnpCZEl6cfDCQe5WfoCpMLFvWKZ3TgaOhyW9vTc/8/+TcLBwbX
         5APjMNEj8pIApkNLXh16BC850QR7WvWnnuHpOBNxby1cqhPhWSfrwbce9TGMNTddkYBt
         yiM/YsdPt8ndjGs56N+F9C61xDhzlEGHl6fChbVuZ9ch/jY54Etu/6qV8ryCkMhFXsjD
         urBg==
X-Gm-Message-State: ACgBeo38qYlhRNZIbppErw7kVmy6KbtWTEdM8dDYIcKGeQ/a6hNJ9W1Y
        GKEzRBMoqhIEZ2pwg8+LVyc8SoNNxOT9BbO3q80krKPQcmvmYSn9VWocgLlTF3x3cmD3QT/y0Bc
        6KzckCge9M1ODw+XbDIP+vNOvxzDIfFZftQ+e9A==
X-Received: by 2002:a0d:cc0f:0:b0:334:c52e:83c4 with SMTP id o15-20020a0dcc0f000000b00334c52e83c4mr17694132ywd.324.1661140409173;
        Sun, 21 Aug 2022 20:53:29 -0700 (PDT)
X-Google-Smtp-Source: AA6agR42OnvKq+Ba6NWjPpKZkzPQ7Nw87rq6TpmO9ELF+Oyou5J2pb5qXSBRwo8a/K+Z9qKsWKUHHHhq4kFsyIS4OTE=
X-Received: by 2002:a0d:cc0f:0:b0:334:c52e:83c4 with SMTP id
 o15-20020a0dcc0f000000b00334c52e83c4mr17694120ywd.324.1661140408678; Sun, 21
 Aug 2022 20:53:28 -0700 (PDT)
MIME-Version: 1.0
References: <6300d1f84dd26_5a1d52acd77b1b998717a9@prd-scan-dashboard-0.mail> <004f3c3a275a007dfee7f92787a4541090b18221.camel@kernel.org>
In-Reply-To: <004f3c3a275a007dfee7f92787a4541090b18221.camel@kernel.org>
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Mon, 22 Aug 2022 13:54:42 +1000
Message-ID: <CAF-wwdHAAZLw4UpuHX_ykTVddhR2eZW9h8AkVnEMc4Om8Tqx=A@mail.gmail.com>
Subject: Re: New Defects reported by Coverity Scan for ceph
To:     Jeff Layton <jlayton@kernel.org>
Cc:     dev <dev@ceph.io>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SENDGRID_REDIR,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Aug 20, 2022 at 11:19 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> This mailing list is for the ceph kernel client, but the report below is
> for the userland ceph project. Can you change where these alerts get
> mailed to dev@ceph.io?

Sorry Jeff,

I'm pretty sure I've changed this but let me know if you get anything else.
>
> Thanks,
> Jeff
>
> On Sat, 2022-08-20 at 12:22 +0000, scan-admin@coverity.com wrote:
> > Hi,
> >
> > Please find the latest report on new defect(s) introduced to ceph found=
 with Coverity Scan.
> >
> > 293 new defect(s) introduced to ceph found with Coverity Scan.
> > 2803 defect(s), reported by Coverity Scan earlier, were marked fixed in=
 the recent build analyzed by Coverity Scan.
> >
> > New defect(s) Reported-by: Coverity Scan
> > Showing 20 of 293 defect(s)
> >
> >
> > ** CID 1509769:  Security best practices violations  (DC.WEAK_CRYPTO)
> > /home/kkeithle/src/github/ceph/src/msg/async/ProtocolV2.cc: 1041 in Pro=
tocolV2::handle_hello(ceph::buffer::v15_2_0::list &)()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509769:  Security best practices violations  (DC.WEAK_CRYPTO)
> > /home/kkeithle/src/github/ceph/src/msg/async/ProtocolV2.cc: 1041 in Pro=
tocolV2::handle_hello(ceph::buffer::v15_2_0::list &)()
> > 1035         a.set_type(entity_addr_t::TYPE_MSGR2); // anything but NON=
E; learned_addr ignores this
> > 1036         a.set_port(0);
> > 1037         connection->lock.unlock();
> > 1038         messenger->learned_addr(a);
> > 1039         if (cct->_conf->ms_inject_internal_delays &&
> > 1040             cct->_conf->ms_inject_socket_failures) {
> > > > >     CID 1509769:  Security best practices violations  (DC.WEAK_CR=
YPTO)
> > > > >     "rand" should not be used for security-related applications, =
because linear congruential algorithms are too easy to break.
> > 1041           if (rand() % cct->_conf->ms_inject_socket_failures =3D=
=3D 0) {
> > 1042             ldout(cct, 10) << __func__ << " sleep for "
> > 1043                            << cct->_conf->ms_inject_internal_delay=
s << dendl;
> > 1044             utime_t t;
> > 1045             t.set_from_double(cct->_conf->ms_inject_internal_delay=
s);
> > 1046             t.sleep();
> >
> > ** CID 1509768:  Control flow issues  (UNREACHABLE)
> > /src/pybind/rbd/rbd.c: 30844 in __pyx_pf_3rbd_3RBD_96group_list()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509768:  Control flow issues  (UNREACHABLE)
> > /src/pybind/rbd/rbd.c: 30844 in __pyx_pf_3rbd_3RBD_96group_list()
> > 30838      *                     if name]
> > 30839      *         finally:
> > 30840      *             free(c_names)             # <<<<<<<<<<<<<<
> > 30841      *
> > 30842      *     def group_rename(self, ioctx, src, dest):
> > 30843      */
> > > > >     CID 1509768:  Control flow issues  (UNREACHABLE)
> > > > >     This code cannot be reached: "{
> >   __pyx_L4_error:
> >   ;
> >   {...".
> > 30844       /*finally:*/ {
> > 30845         __pyx_L4_error:;
> > 30846         /*exception exit:*/{
> > 30847           __Pyx_PyThreadState_declare
> > 30848           __Pyx_PyThreadState_assign
> > 30849           __pyx_t_15 =3D 0; __pyx_t_16 =3D 0; __pyx_t_17 =3D 0; _=
_pyx_t_18 =3D 0; __pyx_t_19 =3D 0; __pyx_t_20 =3D 0;
> >
> > ** CID 1509767:    (UNCAUGHT_EXCEPT)
> > /home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in Simple=
RADOSStriper::lock_keeper_main()()
> > /home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in Simple=
RADOSStriper::lock_keeper_main()()
> > /home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in Simple=
RADOSStriper::lock_keeper_main()()
> > /home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in Simple=
RADOSStriper::lock_keeper_main()()
> > /home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in Simple=
RADOSStriper::lock_keeper_main()()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509767:    (UNCAUGHT_EXCEPT)
> > /home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in Simple=
RADOSStriper::lock_keeper_main()()
> > 541     /* Do lock renewal in a separate thread: while it's unlikely sq=
lite chews on
> > 542      * something for multiple seconds without calling into the VFS =
(where we could
> > 543      * initiate a lock renewal), it's not impossible with complex q=
ueries. Also, we
> > 544      * want to allow "PRAGMA locking_mode =3D exclusive" where the =
application may
> > 545      * not use the sqlite3 database connection for an indeterminate=
 amount of time.
> > 546      */
> > > > >     CID 1509767:    (UNCAUGHT_EXCEPT)
> > > > >     In function "SimpleRADOSStriper::lock_keeper_main()" an excep=
tion of type "boost::container::length_error" is thrown and never caught.
> > 547     void SimpleRADOSStriper::lock_keeper_main(void)
> > 548     {
> > 549       d(20) << dendl;
> > 550       const auto ext =3D get_first_extent();
> > 551       while (!shutdown) {
> > 552         d(20) << "tick" << dendl;
> > /home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in Simple=
RADOSStriper::lock_keeper_main()()
> > 541     /* Do lock renewal in a separate thread: while it's unlikely sq=
lite chews on
> > 542      * something for multiple seconds without calling into the VFS =
(where we could
> > 543      * initiate a lock renewal), it's not impossible with complex q=
ueries. Also, we
> > 544      * want to allow "PRAGMA locking_mode =3D exclusive" where the =
application may
> > 545      * not use the sqlite3 database connection for an indeterminate=
 amount of time.
> > 546      */
> > > > >     CID 1509767:    (UNCAUGHT_EXCEPT)
> > > > >     In function "SimpleRADOSStriper::lock_keeper_main()" an excep=
tion of type "boost::container::length_error" is thrown and never caught.
> > 547     void SimpleRADOSStriper::lock_keeper_main(void)
> > 548     {
> > 549       d(20) << dendl;
> > 550       const auto ext =3D get_first_extent();
> > 551       while (!shutdown) {
> > 552         d(20) << "tick" << dendl;
> > /home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in Simple=
RADOSStriper::lock_keeper_main()()
> > 541     /* Do lock renewal in a separate thread: while it's unlikely sq=
lite chews on
> > 542      * something for multiple seconds without calling into the VFS =
(where we could
> > 543      * initiate a lock renewal), it's not impossible with complex q=
ueries. Also, we
> > 544      * want to allow "PRAGMA locking_mode =3D exclusive" where the =
application may
> > 545      * not use the sqlite3 database connection for an indeterminate=
 amount of time.
> > 546      */
> > > > >     CID 1509767:    (UNCAUGHT_EXCEPT)
> > > > >     In function "SimpleRADOSStriper::lock_keeper_main()" an excep=
tion of type "boost::container::length_error" is thrown and never caught.
> > 547     void SimpleRADOSStriper::lock_keeper_main(void)
> > 548     {
> > 549       d(20) << dendl;
> > 550       const auto ext =3D get_first_extent();
> > 551       while (!shutdown) {
> > 552         d(20) << "tick" << dendl;
> > /home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in Simple=
RADOSStriper::lock_keeper_main()()
> > 541     /* Do lock renewal in a separate thread: while it's unlikely sq=
lite chews on
> > 542      * something for multiple seconds without calling into the VFS =
(where we could
> > 543      * initiate a lock renewal), it's not impossible with complex q=
ueries. Also, we
> > 544      * want to allow "PRAGMA locking_mode =3D exclusive" where the =
application may
> > 545      * not use the sqlite3 database connection for an indeterminate=
 amount of time.
> > 546      */
> > > > >     CID 1509767:    (UNCAUGHT_EXCEPT)
> > > > >     In function "SimpleRADOSStriper::lock_keeper_main()" an excep=
tion of type "boost::container::length_error" is thrown and never caught.
> > 547     void SimpleRADOSStriper::lock_keeper_main(void)
> > 548     {
> > 549       d(20) << dendl;
> > 550       const auto ext =3D get_first_extent();
> > 551       while (!shutdown) {
> > 552         d(20) << "tick" << dendl;
> > /home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in Simple=
RADOSStriper::lock_keeper_main()()
> > 541     /* Do lock renewal in a separate thread: while it's unlikely sq=
lite chews on
> > 542      * something for multiple seconds without calling into the VFS =
(where we could
> > 543      * initiate a lock renewal), it's not impossible with complex q=
ueries. Also, we
> > 544      * want to allow "PRAGMA locking_mode =3D exclusive" where the =
application may
> > 545      * not use the sqlite3 database connection for an indeterminate=
 amount of time.
> > 546      */
> > > > >     CID 1509767:    (UNCAUGHT_EXCEPT)
> > > > >     In function "SimpleRADOSStriper::lock_keeper_main()" an excep=
tion of type "boost::container::length_error" is thrown and never caught.
> > 547     void SimpleRADOSStriper::lock_keeper_main(void)
> > 548     {
> > 549       d(20) << dendl;
> > 550       const auto ext =3D get_first_extent();
> > 551       while (!shutdown) {
> > 552         d(20) << "tick" << dendl;
> >
> > ** CID 1509766:  Uninitialized members  (UNINIT_CTOR)
> > /home/kkeithle/src/github/ceph/src/messages/MMDSSnapUpdate.h: 32 in MMD=
SSnapUpdate::MMDSSnapUpdate()()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509766:  Uninitialized members  (UNINIT_CTOR)
> > /home/kkeithle/src/github/ceph/src/messages/MMDSSnapUpdate.h: 32 in MMD=
SSnapUpdate::MMDSSnapUpdate()()
> > 26       inodeno_t get_ino() const { return ino; }
> > 27       int get_snap_op() const { return snap_op; }
> > 28
> > 29       ceph::buffer::list snap_blob;
> > 30
> > 31     protected:
> > > > >     CID 1509766:  Uninitialized members  (UNINIT_CTOR)
> > > > >     Non-static class member "snap_op" is not initialized in this =
constructor nor in any functions that it calls.
> > 32       MMDSSnapUpdate() : MMDSOp{MSG_MDS_SNAPUPDATE} {}
> > 33       MMDSSnapUpdate(inodeno_t i, version_t tid, int op) :
> > 34         MMDSOp{MSG_MDS_SNAPUPDATE}, ino(i), snap_op(op) {
> > 35           set_tid(tid);
> > 36         }
> > 37       ~MMDSSnapUpdate() final {}
> >
> > ** CID 1509765:  Performance inefficiencies  (AUTO_CAUSES_COPY)
> > /home/kkeithle/src/github/ceph/src/common/ceph_json.cc: 934 in JSONForm=
attable::encode_json(const char *, ceph::Formatter *) const()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509765:  Performance inefficiencies  (AUTO_CAUSES_COPY)
> > /home/kkeithle/src/github/ceph/src/common/ceph_json.cc: 934 in JSONForm=
attable::encode_json(const char *, ceph::Formatter *) const()
> > 928           break;
> > 929         case JSONFormattable::FMT_ARRAY:
> > 930           ::encode_json(name, arr, f);
> > 931           break;
> > 932         case JSONFormattable::FMT_OBJ:
> > 933           f->open_object_section(name);
> > > > >     CID 1509765:  Performance inefficiencies  (AUTO_CAUSES_COPY)
> > > > >     Using the "auto" keyword without an "&" causes the copy of an=
 object of type pair.
> > 934           for (auto iter : obj) {
> > 935             ::encode_json(iter.first.c_str(), iter.second, f);
> > 936           }
> > 937           f->close_section();
> > 938           break;
> > 939         case JSONFormattable::FMT_NONE:
> >
> > ** CID 1509764:  Concurrent data access violations  (MISSING_LOCK)
> > /home/kkeithle/src/github/ceph/src/common/Finisher.cc: 93 in Finisher::=
finisher_thread_entry()()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509764:  Concurrent data access violations  (MISSING_LOCK)
> > /home/kkeithle/src/github/ceph/src/common/Finisher.cc: 93 in Finisher::=
finisher_thread_entry()()
> > 87       }
> > 88       // If we are exiting, we signal the thread waiting in stop(),
> > 89       // otherwise it would never unblock
> > 90       finisher_empty_cond.notify_all();
> > 91
> > 92       ldout(cct, 10) << "finisher_thread stop" << dendl;
> > > > >     CID 1509764:  Concurrent data access violations  (MISSING_LOC=
K)
> > > > >     Accessing "this->finisher_stop" without holding lock "ceph::m=
utex_debug_detail::mutex_debug_impl<false>.m". Elsewhere, "Finisher.finishe=
r_stop" is accessed with "mutex_debug_impl.m" held 1 out of 2 times (1 of t=
hese accesses strongly imply that it is necessary).
> > 93       finisher_stop =3D false;
> > 94       return 0;
> >
> > ** CID 1509763:    (UNCAUGHT_EXCEPT)
> > /home/kkeithle/src/github/ceph/src/msg/async/rdma/Infiniband.cc: 1255 i=
n Infiniband::QueuePair::~QueuePair()()
> > /home/kkeithle/src/github/ceph/src/msg/async/rdma/Infiniband.cc: 1255 i=
n Infiniband::QueuePair::~QueuePair()()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509763:    (UNCAUGHT_EXCEPT)
> > /home/kkeithle/src/github/ceph/src/msg/async/rdma/Infiniband.cc: 1255 i=
n Infiniband::QueuePair::~QueuePair()()
> > 1249         delete cq;
> > 1250         return NULL;
> > 1251       }
> > 1252       return cq;
> > 1253     }
> > 1254
> > > > >     CID 1509763:    (UNCAUGHT_EXCEPT)
> > > > >     An exception of type "boost::container::length_error" is thro=
wn but the exception specification "noexcept" doesn't allow it to be thrown=
. This will result in a call to terminate().
> > 1255     Infiniband::QueuePair::~QueuePair()
> > 1256     {
> > 1257       ldout(cct, 20) << __func__ << " destroy Queue Pair, qp numbe=
r: " << qp->qp_num << " left SQ WR " << recv_queue.size() << dendl;
> > 1258       if (qp) {
> > 1259         ldout(cct, 20) << __func__ << " destroy qp=3D" << qp << de=
ndl;
> > 1260         ceph_assert(!ibv_destroy_qp(qp));
> > /home/kkeithle/src/github/ceph/src/msg/async/rdma/Infiniband.cc: 1255 i=
n Infiniband::QueuePair::~QueuePair()()
> > 1249         delete cq;
> > 1250         return NULL;
> > 1251       }
> > 1252       return cq;
> > 1253     }
> > 1254
> > > > >     CID 1509763:    (UNCAUGHT_EXCEPT)
> > > > >     An exception of type "boost::container::length_error" is thro=
wn but the exception specification "noexcept" doesn't allow it to be thrown=
. This will result in a call to terminate().
> > 1255     Infiniband::QueuePair::~QueuePair()
> > 1256     {
> > 1257       ldout(cct, 20) << __func__ << " destroy Queue Pair, qp numbe=
r: " << qp->qp_num << " left SQ WR " << recv_queue.size() << dendl;
> > 1258       if (qp) {
> > 1259         ldout(cct, 20) << __func__ << " destroy qp=3D" << qp << de=
ndl;
> > 1260         ceph_assert(!ibv_destroy_qp(qp));
> >
> > ** CID 1509762:  Error handling issues  (UNCAUGHT_EXCEPT)
> > /home/kkeithle/src/github/ceph/src/msg/async/rdma/Infiniband.cc: 1255 i=
n Infiniband::QueuePair::~QueuePair()()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509762:  Error handling issues  (UNCAUGHT_EXCEPT)
> > /home/kkeithle/src/github/ceph/src/msg/async/rdma/Infiniband.cc: 1255 i=
n Infiniband::QueuePair::~QueuePair()()
> > 1249         delete cq;
> > 1250         return NULL;
> > 1251       }
> > 1252       return cq;
> > 1253     }
> > 1254
> > > > >     CID 1509762:  Error handling issues  (UNCAUGHT_EXCEPT)
> > > > >     An exception of type "std::system_error" is thrown but the ex=
ception specification "noexcept" doesn't allow it to be thrown. This will r=
esult in a call to terminate().
> > 1255     Infiniband::QueuePair::~QueuePair()
> > 1256     {
> > 1257       ldout(cct, 20) << __func__ << " destroy Queue Pair, qp numbe=
r: " << qp->qp_num << " left SQ WR " << recv_queue.size() << dendl;
> > 1258       if (qp) {
> > 1259         ldout(cct, 20) << __func__ << " destroy qp=3D" << qp << de=
ndl;
> > 1260         ceph_assert(!ibv_destroy_qp(qp));
> >
> > ** CID 1509761:  Error handling issues  (CHECKED_RETURN)
> > /src/pybind/rados/rados.c: 56264 in __pyx_pw_5rados_5Ioctx_87watch()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509761:  Error handling issues  (CHECKED_RETURN)
> > /src/pybind/rados/rados.c: 56264 in __pyx_pw_5rados_5Ioctx_87watch()
> > 56258       __Pyx_RaiseArgtupleInvalid("watch", 0, 2, 4, PyTuple_GET_SI=
ZE(__pyx_args)); __PYX_ERR(0, 3314, __pyx_L3_error)
> > 56259       __pyx_L3_error:;
> > 56260       __Pyx_AddTraceback("rados.Ioctx.watch", __pyx_clineno, __py=
x_lineno, __pyx_filename);
> > 56261       __Pyx_RefNannyFinishContext();
> > 56262       return NULL;
> > 56263       __pyx_L4_argument_unpacking_done:;
> > > > >     CID 1509761:  Error handling issues  (CHECKED_RETURN)
> > > > >     Calling "__Pyx__ArgTypeTest" without checking return value (a=
s is done elsewhere 132 out of 132 times).
> > 56264       if (unlikely(!__Pyx_ArgTypeTest(((PyObject *)__pyx_v_obj), =
(&PyUnicode_Type), 1, "obj", 1))) __PYX_ERR(0, 3314, __pyx_L1_error)
> > 56265       __pyx_r =3D __pyx_pf_5rados_5Ioctx_86watch(((struct __pyx_o=
bj_5rados_Ioctx *)__pyx_v_self), __pyx_v_obj, __pyx_v_callback, __pyx_v_err=
or_callback, __pyx_v_timeout);
> > 56266
> > 56267       /* "rados.pyx":3314
> > 56268      *         return completion
> > 56269      *
> >
> > ** CID 1509760:  Error handling issues  (CHECKED_RETURN)
> > /src/pybind/rados/rados.c: 47064 in __pyx_pw_5rados_5Ioctx_37aio_remove=
()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509760:  Error handling issues  (CHECKED_RETURN)
> > /src/pybind/rados/rados.c: 47064 in __pyx_pw_5rados_5Ioctx_37aio_remove=
()
> > 47058       __Pyx_RaiseArgtupleInvalid("aio_remove", 0, 1, 3, PyTuple_G=
ET_SIZE(__pyx_args)); __PYX_ERR(0, 2640, __pyx_L3_error)
> > 47059       __pyx_L3_error:;
> > 47060       __Pyx_AddTraceback("rados.Ioctx.aio_remove", __pyx_clineno,=
 __pyx_lineno, __pyx_filename);
> > 47061       __Pyx_RefNannyFinishContext();
> > 47062       return NULL;
> > 47063       __pyx_L4_argument_unpacking_done:;
> > > > >     CID 1509760:  Error handling issues  (CHECKED_RETURN)
> > > > >     Calling "__Pyx__ArgTypeTest" without checking return value (a=
s is done elsewhere 132 out of 132 times).
> > 47064       if (unlikely(!__Pyx_ArgTypeTest(((PyObject *)__pyx_v_object=
_name), (&PyUnicode_Type), 1, "object_name", 1))) __PYX_ERR(0, 2640, __pyx_=
L1_error)
> > 47065       __pyx_r =3D __pyx_pf_5rados_5Ioctx_36aio_remove(((struct __=
pyx_obj_5rados_Ioctx *)__pyx_v_self), __pyx_v_object_name, __pyx_v_oncomple=
te, __pyx_v_onsafe);
> > 47066
> > 47067       /* "rados.pyx":2640
> > 47068      *         return completion
> > 47069      *
> >
> > ** CID 1509759:  Program hangs  (SLEEP)
> > /home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 703 in Simple=
RADOSStriper::lock(unsigned long)()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509759:  Program hangs  (SLEEP)
> > /home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 703 in Simple=
RADOSStriper::lock(unsigned long)()
> > 697         } else if (rc =3D=3D -EBUSY) {
> > 698           if ((slept % 500000) =3D=3D 0) {
> > 699             d(-1) << "waiting for locks: ";
> > 700             print_lockers(*_dout);
> > 701             *_dout << dendl;
> > 702           }
> > > > >     CID 1509759:  Program hangs  (SLEEP)
> > > > >     Call to "usleep" might sleep while holding lock "lock._M_devi=
ce".
> > 703           usleep(5000);
> > 704           slept +=3D 5000;
> > 705           continue;
> > 706         } else if (rc =3D=3D -ECANCELED) {
> > 707           /* CMPXATTR failed, a locker didn't cleanup. Try to recov=
er! */
> > 708           if (rc =3D recover_lock(); rc < 0) {
> >
> > ** CID 1509758:  Error handling issues  (CHECKED_RETURN)
> > /src/pybind/rbd/rbd.c: 81568 in __pyx_pw_3rbd_17GroupSnapIterator_1__in=
it__()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509758:  Error handling issues  (CHECKED_RETURN)
> > /src/pybind/rbd/rbd.c: 81568 in __pyx_pw_3rbd_17GroupSnapIterator_1__in=
it__()
> > 81562       __Pyx_RaiseArgtupleInvalid("__init__", 1, 1, 1, PyTuple_GET=
_SIZE(__pyx_args)); __PYX_ERR(0, 5773, __pyx_L3_error)
> > 81563       __pyx_L3_error:;
> > 81564       __Pyx_AddTraceback("rbd.GroupSnapIterator.__init__", __pyx_=
clineno, __pyx_lineno, __pyx_filename);
> > 81565       __Pyx_RefNannyFinishContext();
> > 81566       return -1;
> > 81567       __pyx_L4_argument_unpacking_done:;
> > > > >     CID 1509758:  Error handling issues  (CHECKED_RETURN)
> > > > >     Calling "__Pyx__ArgTypeTest" without checking return value (a=
s is done elsewhere 8 out of 8 times).
> > 81568       if (unlikely(!__Pyx_ArgTypeTest(((PyObject *)__pyx_v_group)=
, __pyx_ptype_3rbd_Group, 1, "group", 0))) __PYX_ERR(0, 5773, __pyx_L1_erro=
r)
> > 81569       __pyx_r =3D __pyx_pf_3rbd_17GroupSnapIterator___init__(((st=
ruct __pyx_obj_3rbd_GroupSnapIterator *)__pyx_v_self), __pyx_v_group);
> > 81570
> > 81571       /* function exit code */
> > 81572       goto __pyx_L0;
> > 81573       __pyx_L1_error:;
> >
> > ** CID 1509757:  Error handling issues  (CHECKED_RETURN)
> > /src/pybind/rados/rados.c: 47527 in __pyx_pw_5rados_5Ioctx_41set_locato=
r_key()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509757:  Error handling issues  (CHECKED_RETURN)
> > /src/pybind/rados/rados.c: 47527 in __pyx_pw_5rados_5Ioctx_41set_locato=
r_key()
> > 47521       int __pyx_lineno =3D 0;
> > 47522       const char *__pyx_filename =3D NULL;
> > 47523       int __pyx_clineno =3D 0;
> > 47524       PyObject *__pyx_r =3D 0;
> > 47525       __Pyx_RefNannyDeclarations
> > 47526       __Pyx_RefNannySetupContext("set_locator_key (wrapper)", 0);
> > > > >     CID 1509757:  Error handling issues  (CHECKED_RETURN)
> > > > >     Calling "__Pyx__ArgTypeTest" without checking return value (a=
s is done elsewhere 132 out of 132 times).
> > 47527       if (unlikely(!__Pyx_ArgTypeTest(((PyObject *)__pyx_v_loc_ke=
y), (&PyUnicode_Type), 1, "loc_key", 1))) __PYX_ERR(0, 2680, __pyx_L1_error=
)
> > 47528       __pyx_r =3D __pyx_pf_5rados_5Ioctx_40set_locator_key(((stru=
ct __pyx_obj_5rados_Ioctx *)__pyx_v_self), ((PyObject*)__pyx_v_loc_key));
> > 47529
> > 47530       /* function exit code */
> > 47531       goto __pyx_L0;
> > 47532       __pyx_L1_error:;
> >
> > ** CID 1509756:    (CHECKED_RETURN)
> > /src/pybind/rgw/rgw.c: 29532 in __Pyx_PyUnicode_Join()
> > /src/pybind/cephfs/cephfs.c: 44814 in __Pyx_PyUnicode_Join()
> > /src/pybind/rbd/rbd.c: 99756 in __Pyx_PyUnicode_Join()
> > /src/pybind/rados/rados.c: 89361 in __Pyx_PyUnicode_Join()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509756:    (CHECKED_RETURN)
> > /src/pybind/rgw/rgw.c: 29532 in __Pyx_PyUnicode_Join()
> > 29526         char_pos =3D 0;
> > 29527         for (i=3D0; i < value_count; i++) {
> > 29528             int ukind;
> > 29529             Py_ssize_t ulength;
> > 29530             void *udata;
> > 29531             PyObject *uval =3D PyTuple_GET_ITEM(value_tuple, i);
> > > > >     CID 1509756:    (CHECKED_RETURN)
> > > > >     Calling "_PyUnicode_Ready" without checking return value (as =
is done elsewhere 8 out of 8 times).
> > 29532             if (unlikely(__Pyx_PyUnicode_READY(uval)))
> > 29533                 goto bad;
> > 29534             ulength =3D __Pyx_PyUnicode_GET_LENGTH(uval);
> > 29535             if (unlikely(!ulength))
> > 29536                 continue;
> > 29537             if (unlikely(char_pos + ulength < 0))
> > /src/pybind/cephfs/cephfs.c: 44814 in __Pyx_PyUnicode_Join()
> > 44808         char_pos =3D 0;
> > 44809         for (i=3D0; i < value_count; i++) {
> > 44810             int ukind;
> > 44811             Py_ssize_t ulength;
> > 44812             void *udata;
> > 44813             PyObject *uval =3D PyTuple_GET_ITEM(value_tuple, i);
> > > > >     CID 1509756:    (CHECKED_RETURN)
> > > > >     Calling "_PyUnicode_Ready" without checking return value (as =
is done elsewhere 8 out of 8 times).
> > 44814             if (unlikely(__Pyx_PyUnicode_READY(uval)))
> > 44815                 goto bad;
> > 44816             ulength =3D __Pyx_PyUnicode_GET_LENGTH(uval);
> > 44817             if (unlikely(!ulength))
> > 44818                 continue;
> > 44819             if (unlikely(char_pos + ulength < 0))
> > /src/pybind/rbd/rbd.c: 99756 in __Pyx_PyUnicode_Join()
> > 99750         char_pos =3D 0;
> > 99751         for (i=3D0; i < value_count; i++) {
> > 99752             int ukind;
> > 99753             Py_ssize_t ulength;
> > 99754             void *udata;
> > 99755             PyObject *uval =3D PyTuple_GET_ITEM(value_tuple, i);
> > > > >     CID 1509756:    (CHECKED_RETURN)
> > > > >     Calling "_PyUnicode_Ready" without checking return value (as =
is done elsewhere 8 out of 8 times).
> > 99756             if (unlikely(__Pyx_PyUnicode_READY(uval)))
> > 99757                 goto bad;
> > 99758             ulength =3D __Pyx_PyUnicode_GET_LENGTH(uval);
> > 99759             if (unlikely(!ulength))
> > 99760                 continue;
> > 99761             if (unlikely(char_pos + ulength < 0))
> > /src/pybind/rados/rados.c: 89361 in __Pyx_PyUnicode_Join()
> > 89355         char_pos =3D 0;
> > 89356         for (i=3D0; i < value_count; i++) {
> > 89357             int ukind;
> > 89358             Py_ssize_t ulength;
> > 89359             void *udata;
> > 89360             PyObject *uval =3D PyTuple_GET_ITEM(value_tuple, i);
> > > > >     CID 1509756:    (CHECKED_RETURN)
> > > > >     Calling "_PyUnicode_Ready" without checking return value (as =
is done elsewhere 8 out of 8 times).
> > 89361             if (unlikely(__Pyx_PyUnicode_READY(uval)))
> > 89362                 goto bad;
> > 89363             ulength =3D __Pyx_PyUnicode_GET_LENGTH(uval);
> > 89364             if (unlikely(!ulength))
> > 89365                 continue;
> > 89366             if (unlikely(char_pos + ulength < 0))
> >
> > ** CID 1509755:  Control flow issues  (UNREACHABLE)
> > /src/pybind/rbd/rbd.c: 72245 in __pyx_pf_3rbd_5Image_210snap_get_trash_=
namespace()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509755:  Control flow issues  (UNREACHABLE)
> > /src/pybind/rbd/rbd.c: 72245 in __pyx_pf_3rbd_5Image_210snap_get_trash_=
namespace()
> > 72239      *                 }
> > 72240      *         finally:
> > 72241      *             free(_name)             # <<<<<<<<<<<<<<
> > 72242      *
> > 72243      *     @requires_not_closed
> > 72244      */
> > > > >     CID 1509755:  Control flow issues  (UNREACHABLE)
> > > > >     This code cannot be reached: "{
> >   __pyx_L4_error:
> >   ;
> >   {...".
> > 72245       /*finally:*/ {
> > 72246         __pyx_L4_error:;
> > 72247         /*exception exit:*/{
> > 72248           __Pyx_PyThreadState_declare
> > 72249           __Pyx_PyThreadState_assign
> > 72250           __pyx_t_14 =3D 0; __pyx_t_15 =3D 0; __pyx_t_16 =3D 0; _=
_pyx_t_17 =3D 0; __pyx_t_18 =3D 0; __pyx_t_19 =3D 0;
> >
> > ** CID 1509754:  Uninitialized members  (UNINIT_CTOR)
> > /home/kkeithle/src/github/ceph/src/messages/MMDSPing.h: 19 in MMDSPing:=
:MMDSPing()()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509754:  Uninitialized members  (UNINIT_CTOR)
> > /home/kkeithle/src/github/ceph/src/messages/MMDSPing.h: 19 in MMDSPing:=
:MMDSPing()()
> > 13       static constexpr int COMPAT_VERSION =3D 1;
> > 14     public:
> > 15       version_t seq;
> > 16
> > 17     protected:
> > 18       MMDSPing() : MMDSOp(MSG_MDS_PING, HEAD_VERSION, COMPAT_VERSION=
) {
> > > > >     CID 1509754:  Uninitialized members  (UNINIT_CTOR)
> > > > >     Non-static class member "seq" is not initialized in this cons=
tructor nor in any functions that it calls.
> > 19       }
> > 20       MMDSPing(version_t seq)
> > 21         : MMDSOp(MSG_MDS_PING, HEAD_VERSION, COMPAT_VERSION), seq(se=
q) {
> > 22       }
> > 23       ~MMDSPing() final {}
> > 24
> >
> > ** CID 1509753:  Error handling issues  (UNCAUGHT_EXCEPT)
> > /home/kkeithle/src/github/ceph/src/osdc/Objecter.cc: 5005 in Objecter::=
~Objecter()()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509753:  Error handling issues  (UNCAUGHT_EXCEPT)
> > /home/kkeithle/src/github/ceph/src/osdc/Objecter.cc: 5005 in Objecter::=
~Objecter()()
> > 4999       Dispatcher(cct), messenger(m), monc(mc), service(service)
> > 5000     {
> > 5001       mon_timeout =3D cct->_conf.get_val<std::chrono::seconds>("ra=
dos_mon_op_timeout");
> > 5002       osd_timeout =3D cct->_conf.get_val<std::chrono::seconds>("ra=
dos_osd_op_timeout");
> > 5003     }
> > 5004
> > > > >     CID 1509753:  Error handling issues  (UNCAUGHT_EXCEPT)
> > > > >     An exception of type "boost::container::length_error" is thro=
wn but the exception specification "noexcept" doesn't allow it to be thrown=
. This will result in a call to terminate().
> > 5005     Objecter::~Objecter()
> > 5006     {
> > 5007       ceph_assert(homeless_session->get_nref() =3D=3D 1);
> > 5008       ceph_assert(num_homeless_ops =3D=3D 0);
> > 5009       homeless_session->put();
> > 5010
> >
> > ** CID 1509752:  Error handling issues  (CHECKED_RETURN)
> > /src/pybind/rados/rados.c: 63069 in __pyx_pw_5rados_5Ioctx_139remove_om=
ap_keys()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509752:  Error handling issues  (CHECKED_RETURN)
> > /src/pybind/rados/rados.c: 63069 in __pyx_pw_5rados_5Ioctx_139remove_om=
ap_keys()
> > 63063       __Pyx_RaiseArgtupleInvalid("remove_omap_keys", 1, 2, 2, PyT=
uple_GET_SIZE(__pyx_args)); __PYX_ERR(0, 3821, __pyx_L3_error)
> > 63064       __pyx_L3_error:;
> > 63065       __Pyx_AddTraceback("rados.Ioctx.remove_omap_keys", __pyx_cl=
ineno, __pyx_lineno, __pyx_filename);
> > 63066       __Pyx_RefNannyFinishContext();
> > 63067       return NULL;
> > 63068       __pyx_L4_argument_unpacking_done:;
> > > > >     CID 1509752:  Error handling issues  (CHECKED_RETURN)
> > > > >     Calling "__Pyx__ArgTypeTest" without checking return value (a=
s is done elsewhere 19 out of 19 times).
> > 63069       if (unlikely(!__Pyx_ArgTypeTest(((PyObject *)__pyx_v_write_=
op), __pyx_ptype_5rados_WriteOp, 1, "write_op", 0))) __PYX_ERR(0, 3821, __p=
yx_L1_error)
> > 63070       __pyx_r =3D __pyx_pf_5rados_5Ioctx_138remove_omap_keys(((st=
ruct __pyx_obj_5rados_Ioctx *)__pyx_v_self), __pyx_v_write_op, __pyx_v_keys=
);
> > 63071
> > 63072       /* function exit code */
> > 63073       goto __pyx_L0;
> > 63074       __pyx_L1_error:;
> >
> > ** CID 1509751:  Memory - illegal accesses  (USE_AFTER_FREE)
> > /home/kkeithle/src/github/ceph/src/msg/async/ProtocolV2.cc: 1399 in Pro=
tocolV2::handle_message()()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509751:  Memory - illegal accesses  (USE_AFTER_FREE)
> > /home/kkeithle/src/github/ceph/src/msg/async/ProtocolV2.cc: 1399 in Pro=
tocolV2::handle_message()()
> > 1393         ldout(cct, 1) << __func__ << " decode message failed " << =
dendl;
> > 1394         return _fault();
> > 1395       } else {
> > 1396         state =3D READ_MESSAGE_COMPLETE;
> > 1397       }
> > 1398
> > > > >     CID 1509751:  Memory - illegal accesses  (USE_AFTER_FREE)
> > > > >     Using freed pointer "this->connection".
> > 1399       INTERCEPT(17);
> > 1400
> > 1401       message->set_byte_throttler(connection->policy.throttler_byt=
es);
> > 1402       message->set_message_throttler(connection->policy.throttler_=
messages);
> > 1403
> > 1404       // store reservation size in message, so we don't get confus=
ed
> >
> > ** CID 1509750:  Error handling issues  (UNCAUGHT_EXCEPT)
> > /home/kkeithle/src/github/ceph/src/common/perf_counters_collection.cc: =
55 in ceph::common::PerfCountersDeleter::operator ()(ceph::common::PerfCoun=
ters *)()
> >
> >
> > _______________________________________________________________________=
_________________________________
> > *** CID 1509750:  Error handling issues  (UNCAUGHT_EXCEPT)
> > /home/kkeithle/src/github/ceph/src/common/perf_counters_collection.cc: =
55 in ceph::common::PerfCountersDeleter::operator ()(ceph::common::PerfCoun=
ters *)()
> > 49     }
> > 50     void PerfCountersCollection::with_counters(std::function<void(co=
nst PerfCountersCollectionImpl::CounterMap &)> fn) const
> > 51     {
> > 52       std::lock_guard lck(m_lock);
> > 53       perf_impl.with_counters(fn);
> > 54     }
> > > > >     CID 1509750:  Error handling issues  (UNCAUGHT_EXCEPT)
> > > > >     An exception of type "std::system_error" is thrown but the ex=
ception specification "noexcept" doesn't allow it to be thrown. This will r=
esult in a call to terminate().
> > 55     void PerfCountersDeleter::operator()(PerfCounters* p) noexcept
> > 56     {
> > 57       if (cct)
> > 58         cct->get_perfcounters_collection()->remove(p);
> > 59       delete p;
> > 60     }
> > 61
> >
> >
> > _______________________________________________________________________=
_________________________________
> > To view the defects in Coverity Scan visit, https://u15810271.ct.sendgr=
id.net/ls/click?upn=3DHRESupC-2F2Czv4BOaCWWCy7my0P0qcxCbhZ31OYv50yojIR8ODHc=
GVd1JcCGjvdH5QZ17VgLZQT3XYfB8Bhzp4w-3D-3Dapsi_yvgqM0IBcPiStiVTuWpgYFnMA4H-2=
BJYqMHWw4jQPoaoo-2BtqsVYKtfl9A0JRaS-2FbbUsKzdvQMj2WBidmXXDYpXO5qx9Y4cnFn0p-=
2FQkZWWe5JHh8ejaBgEwaUzBM3x-2FyM-2FOpvKqhT-2BCzg-2FNUNemZtHf5voIH7BYbWLrdio=
yp5fcmOVIoUi-2FywPSoY8zfzN1w6jANMlnLaDKN7b-2BOFQMLI5WK5wsImAoh9oNG6AqvJrylM=
M-3D
> >
>
> --
> Jeff Layton <jlayton@kernel.org>
>


--=20
Cheers,
Brad

