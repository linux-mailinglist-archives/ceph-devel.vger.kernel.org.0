Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41CB59ADE3
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Aug 2022 14:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345238AbiHTMXy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 20 Aug 2022 08:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiHTMXw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 20 Aug 2022 08:23:52 -0400
X-Greylist: delayed 92 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 20 Aug 2022 05:23:50 PDT
Received: from wrqvxxsf.outbound-mail.sendgrid.net (wrqvxxsf.outbound-mail.sendgrid.net [149.72.170.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD292CDF0
        for <ceph-devel@vger.kernel.org>; Sat, 20 Aug 2022 05:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=coverity.com;
        h=from:subject:mime-version:to:content-type:content-transfer-encoding:
        cc;
        s=sc; bh=JAuySmSWa0JRlxmtNVMwP2+9Bo0Cc+Zzs1Uu183qSsU=;
        b=JGviFmOpWvsbsTcZXdJn1YLifA2VV10Dk2ODr1jqkTKJAERuDp2efAPaawFJIR7gERxi
        FQxcwQ5qwddLDCUwfS0srCDDhJXhy8PYKXWHKsqNSevFM5clJ8XgxU7Lb9y2cZDll3VM+P
        Qs9oLreHmj2MYKig4pedouXVqvC3FhUI+bloH8y4HW4pZGNyX+qKV9dCZxsWGDv+aRPEwB
        C9HkzXm3OX+W88nAyGBUuiut6d/7SbG+plg9C9iqYX9YVgIeQAbOtyJ7gP5kaXQvha0aKI
        3v+OKE0MbeFFlwr8LbO9CcVT3zTheZk/v+z3c34gsaALVmvvEF2UhG2Zdj5PUTug==
Received: by filterdrecv-86cfc59b8c-x6wjk with SMTP id filterdrecv-86cfc59b8c-x6wjk-1-6300D1F8-23
        2022-08-20 12:22:16.809622959 +0000 UTC m=+2564173.916046516
Received: from coverity.com (unknown)
        by geopod-ismtpd-3-5 (SG) with ESMTP
        id iHSrb8CkSWefUusIWhWpCQ
        Sat, 20 Aug 2022 12:22:16.645 +0000 (UTC)
Date:   Sat, 20 Aug 2022 12:22:16 +0000 (UTC)
From:   scan-admin@coverity.com
Message-ID: <6300d1f84dd26_5a1d52acd77b1b998717a9@prd-scan-dashboard-0.mail>
Subject: New Defects reported by Coverity Scan for ceph
Mime-Version: 1.0
X-SG-EID: =?us-ascii?Q?HBOmY=2FE5MTYb8Mhr7ulQJIaFxcZEWpCD=2F7YwgOg+H8sX=2FMoCMcIhqW56W3QTOF?=
 =?us-ascii?Q?0rzNANOA4WE07MLgynOLHIpbIgL61UJN208u0gl?=
 =?us-ascii?Q?kO+fQodcYXMpSqG6Y21lK1mnAOHKrJnMigy4iD7?=
 =?us-ascii?Q?++bq83l3RNCnurfnvssH1VCofg3uZEyKEOYlTq+?=
 =?us-ascii?Q?ms70wSUpoVniqQisnPNK9lkyzfpBZAydxFMM6zo?=
 =?us-ascii?Q?h6VNMn9qGv9=2FOUwDs=3D?=
To:     ceph-devel@vger.kernel.org
X-Entity-ID: S2cgcZKcMUFZg9Mweglhkg==
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SENDGRID_REDIR,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

Please find the latest report on new defect(s) introduced to ceph found with Coverity Scan.

293 new defect(s) introduced to ceph found with Coverity Scan.
2803 defect(s), reported by Coverity Scan earlier, were marked fixed in the recent build analyzed by Coverity Scan.

New defect(s) Reported-by: Coverity Scan
Showing 20 of 293 defect(s)


** CID 1509769:  Security best practices violations  (DC.WEAK_CRYPTO)
/home/kkeithle/src/github/ceph/src/msg/async/ProtocolV2.cc: 1041 in ProtocolV2::handle_hello(ceph::buffer::v15_2_0::list &)()


________________________________________________________________________________________________________
*** CID 1509769:  Security best practices violations  (DC.WEAK_CRYPTO)
/home/kkeithle/src/github/ceph/src/msg/async/ProtocolV2.cc: 1041 in ProtocolV2::handle_hello(ceph::buffer::v15_2_0::list &)()
1035         a.set_type(entity_addr_t::TYPE_MSGR2); // anything but NONE; learned_addr ignores this
1036         a.set_port(0);
1037         connection->lock.unlock();
1038         messenger->learned_addr(a);
1039         if (cct->_conf->ms_inject_internal_delays &&
1040             cct->_conf->ms_inject_socket_failures) {
>>>     CID 1509769:  Security best practices violations  (DC.WEAK_CRYPTO)
>>>     "rand" should not be used for security-related applications, because linear congruential algorithms are too easy to break.
1041           if (rand() % cct->_conf->ms_inject_socket_failures == 0) {
1042             ldout(cct, 10) << __func__ << " sleep for "
1043                            << cct->_conf->ms_inject_internal_delays << dendl;
1044             utime_t t;
1045             t.set_from_double(cct->_conf->ms_inject_internal_delays);
1046             t.sleep();

** CID 1509768:  Control flow issues  (UNREACHABLE)
/src/pybind/rbd/rbd.c: 30844 in __pyx_pf_3rbd_3RBD_96group_list()


________________________________________________________________________________________________________
*** CID 1509768:  Control flow issues  (UNREACHABLE)
/src/pybind/rbd/rbd.c: 30844 in __pyx_pf_3rbd_3RBD_96group_list()
30838      *                     if name]
30839      *         finally:
30840      *             free(c_names)             # <<<<<<<<<<<<<<
30841      * 
30842      *     def group_rename(self, ioctx, src, dest):
30843      */
>>>     CID 1509768:  Control flow issues  (UNREACHABLE)
>>>     This code cannot be reached: "{
  __pyx_L4_error:
  ;
  {...".
30844       /*finally:*/ {
30845         __pyx_L4_error:;
30846         /*exception exit:*/{
30847           __Pyx_PyThreadState_declare
30848           __Pyx_PyThreadState_assign
30849           __pyx_t_15 = 0; __pyx_t_16 = 0; __pyx_t_17 = 0; __pyx_t_18 = 0; __pyx_t_19 = 0; __pyx_t_20 = 0;

** CID 1509767:    (UNCAUGHT_EXCEPT)
/home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in SimpleRADOSStriper::lock_keeper_main()()
/home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in SimpleRADOSStriper::lock_keeper_main()()
/home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in SimpleRADOSStriper::lock_keeper_main()()
/home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in SimpleRADOSStriper::lock_keeper_main()()
/home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in SimpleRADOSStriper::lock_keeper_main()()


________________________________________________________________________________________________________
*** CID 1509767:    (UNCAUGHT_EXCEPT)
/home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in SimpleRADOSStriper::lock_keeper_main()()
541     /* Do lock renewal in a separate thread: while it's unlikely sqlite chews on
542      * something for multiple seconds without calling into the VFS (where we could
543      * initiate a lock renewal), it's not impossible with complex queries. Also, we
544      * want to allow "PRAGMA locking_mode = exclusive" where the application may
545      * not use the sqlite3 database connection for an indeterminate amount of time.
546      */
>>>     CID 1509767:    (UNCAUGHT_EXCEPT)
>>>     In function "SimpleRADOSStriper::lock_keeper_main()" an exception of type "boost::container::length_error" is thrown and never caught.
547     void SimpleRADOSStriper::lock_keeper_main(void)
548     {
549       d(20) << dendl;
550       const auto ext = get_first_extent();
551       while (!shutdown) {
552         d(20) << "tick" << dendl;
/home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in SimpleRADOSStriper::lock_keeper_main()()
541     /* Do lock renewal in a separate thread: while it's unlikely sqlite chews on
542      * something for multiple seconds without calling into the VFS (where we could
543      * initiate a lock renewal), it's not impossible with complex queries. Also, we
544      * want to allow "PRAGMA locking_mode = exclusive" where the application may
545      * not use the sqlite3 database connection for an indeterminate amount of time.
546      */
>>>     CID 1509767:    (UNCAUGHT_EXCEPT)
>>>     In function "SimpleRADOSStriper::lock_keeper_main()" an exception of type "boost::container::length_error" is thrown and never caught.
547     void SimpleRADOSStriper::lock_keeper_main(void)
548     {
549       d(20) << dendl;
550       const auto ext = get_first_extent();
551       while (!shutdown) {
552         d(20) << "tick" << dendl;
/home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in SimpleRADOSStriper::lock_keeper_main()()
541     /* Do lock renewal in a separate thread: while it's unlikely sqlite chews on
542      * something for multiple seconds without calling into the VFS (where we could
543      * initiate a lock renewal), it's not impossible with complex queries. Also, we
544      * want to allow "PRAGMA locking_mode = exclusive" where the application may
545      * not use the sqlite3 database connection for an indeterminate amount of time.
546      */
>>>     CID 1509767:    (UNCAUGHT_EXCEPT)
>>>     In function "SimpleRADOSStriper::lock_keeper_main()" an exception of type "boost::container::length_error" is thrown and never caught.
547     void SimpleRADOSStriper::lock_keeper_main(void)
548     {
549       d(20) << dendl;
550       const auto ext = get_first_extent();
551       while (!shutdown) {
552         d(20) << "tick" << dendl;
/home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in SimpleRADOSStriper::lock_keeper_main()()
541     /* Do lock renewal in a separate thread: while it's unlikely sqlite chews on
542      * something for multiple seconds without calling into the VFS (where we could
543      * initiate a lock renewal), it's not impossible with complex queries. Also, we
544      * want to allow "PRAGMA locking_mode = exclusive" where the application may
545      * not use the sqlite3 database connection for an indeterminate amount of time.
546      */
>>>     CID 1509767:    (UNCAUGHT_EXCEPT)
>>>     In function "SimpleRADOSStriper::lock_keeper_main()" an exception of type "boost::container::length_error" is thrown and never caught.
547     void SimpleRADOSStriper::lock_keeper_main(void)
548     {
549       d(20) << dendl;
550       const auto ext = get_first_extent();
551       while (!shutdown) {
552         d(20) << "tick" << dendl;
/home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 547 in SimpleRADOSStriper::lock_keeper_main()()
541     /* Do lock renewal in a separate thread: while it's unlikely sqlite chews on
542      * something for multiple seconds without calling into the VFS (where we could
543      * initiate a lock renewal), it's not impossible with complex queries. Also, we
544      * want to allow "PRAGMA locking_mode = exclusive" where the application may
545      * not use the sqlite3 database connection for an indeterminate amount of time.
546      */
>>>     CID 1509767:    (UNCAUGHT_EXCEPT)
>>>     In function "SimpleRADOSStriper::lock_keeper_main()" an exception of type "boost::container::length_error" is thrown and never caught.
547     void SimpleRADOSStriper::lock_keeper_main(void)
548     {
549       d(20) << dendl;
550       const auto ext = get_first_extent();
551       while (!shutdown) {
552         d(20) << "tick" << dendl;

** CID 1509766:  Uninitialized members  (UNINIT_CTOR)
/home/kkeithle/src/github/ceph/src/messages/MMDSSnapUpdate.h: 32 in MMDSSnapUpdate::MMDSSnapUpdate()()


________________________________________________________________________________________________________
*** CID 1509766:  Uninitialized members  (UNINIT_CTOR)
/home/kkeithle/src/github/ceph/src/messages/MMDSSnapUpdate.h: 32 in MMDSSnapUpdate::MMDSSnapUpdate()()
26       inodeno_t get_ino() const { return ino; }
27       int get_snap_op() const { return snap_op; }
28     
29       ceph::buffer::list snap_blob;
30     
31     protected:
>>>     CID 1509766:  Uninitialized members  (UNINIT_CTOR)
>>>     Non-static class member "snap_op" is not initialized in this constructor nor in any functions that it calls.
32       MMDSSnapUpdate() : MMDSOp{MSG_MDS_SNAPUPDATE} {}
33       MMDSSnapUpdate(inodeno_t i, version_t tid, int op) :
34         MMDSOp{MSG_MDS_SNAPUPDATE}, ino(i), snap_op(op) {
35           set_tid(tid);
36         }
37       ~MMDSSnapUpdate() final {}

** CID 1509765:  Performance inefficiencies  (AUTO_CAUSES_COPY)
/home/kkeithle/src/github/ceph/src/common/ceph_json.cc: 934 in JSONFormattable::encode_json(const char *, ceph::Formatter *) const()


________________________________________________________________________________________________________
*** CID 1509765:  Performance inefficiencies  (AUTO_CAUSES_COPY)
/home/kkeithle/src/github/ceph/src/common/ceph_json.cc: 934 in JSONFormattable::encode_json(const char *, ceph::Formatter *) const()
928           break;
929         case JSONFormattable::FMT_ARRAY:
930           ::encode_json(name, arr, f);
931           break;
932         case JSONFormattable::FMT_OBJ:
933           f->open_object_section(name);
>>>     CID 1509765:  Performance inefficiencies  (AUTO_CAUSES_COPY)
>>>     Using the "auto" keyword without an "&" causes the copy of an object of type pair.
934           for (auto iter : obj) {
935             ::encode_json(iter.first.c_str(), iter.second, f);
936           }
937           f->close_section();
938           break;
939         case JSONFormattable::FMT_NONE:

** CID 1509764:  Concurrent data access violations  (MISSING_LOCK)
/home/kkeithle/src/github/ceph/src/common/Finisher.cc: 93 in Finisher::finisher_thread_entry()()


________________________________________________________________________________________________________
*** CID 1509764:  Concurrent data access violations  (MISSING_LOCK)
/home/kkeithle/src/github/ceph/src/common/Finisher.cc: 93 in Finisher::finisher_thread_entry()()
87       }
88       // If we are exiting, we signal the thread waiting in stop(),
89       // otherwise it would never unblock
90       finisher_empty_cond.notify_all();
91     
92       ldout(cct, 10) << "finisher_thread stop" << dendl;
>>>     CID 1509764:  Concurrent data access violations  (MISSING_LOCK)
>>>     Accessing "this->finisher_stop" without holding lock "ceph::mutex_debug_detail::mutex_debug_impl<false>.m". Elsewhere, "Finisher.finisher_stop" is accessed with "mutex_debug_impl.m" held 1 out of 2 times (1 of these accesses strongly imply that it is necessary).
93       finisher_stop = false;
94       return 0;

** CID 1509763:    (UNCAUGHT_EXCEPT)
/home/kkeithle/src/github/ceph/src/msg/async/rdma/Infiniband.cc: 1255 in Infiniband::QueuePair::~QueuePair()()
/home/kkeithle/src/github/ceph/src/msg/async/rdma/Infiniband.cc: 1255 in Infiniband::QueuePair::~QueuePair()()


________________________________________________________________________________________________________
*** CID 1509763:    (UNCAUGHT_EXCEPT)
/home/kkeithle/src/github/ceph/src/msg/async/rdma/Infiniband.cc: 1255 in Infiniband::QueuePair::~QueuePair()()
1249         delete cq;
1250         return NULL;
1251       }
1252       return cq;
1253     }
1254     
>>>     CID 1509763:    (UNCAUGHT_EXCEPT)
>>>     An exception of type "boost::container::length_error" is thrown but the exception specification "noexcept" doesn't allow it to be thrown. This will result in a call to terminate().
1255     Infiniband::QueuePair::~QueuePair()
1256     {
1257       ldout(cct, 20) << __func__ << " destroy Queue Pair, qp number: " << qp->qp_num << " left SQ WR " << recv_queue.size() << dendl;
1258       if (qp) {
1259         ldout(cct, 20) << __func__ << " destroy qp=" << qp << dendl;
1260         ceph_assert(!ibv_destroy_qp(qp));
/home/kkeithle/src/github/ceph/src/msg/async/rdma/Infiniband.cc: 1255 in Infiniband::QueuePair::~QueuePair()()
1249         delete cq;
1250         return NULL;
1251       }
1252       return cq;
1253     }
1254     
>>>     CID 1509763:    (UNCAUGHT_EXCEPT)
>>>     An exception of type "boost::container::length_error" is thrown but the exception specification "noexcept" doesn't allow it to be thrown. This will result in a call to terminate().
1255     Infiniband::QueuePair::~QueuePair()
1256     {
1257       ldout(cct, 20) << __func__ << " destroy Queue Pair, qp number: " << qp->qp_num << " left SQ WR " << recv_queue.size() << dendl;
1258       if (qp) {
1259         ldout(cct, 20) << __func__ << " destroy qp=" << qp << dendl;
1260         ceph_assert(!ibv_destroy_qp(qp));

** CID 1509762:  Error handling issues  (UNCAUGHT_EXCEPT)
/home/kkeithle/src/github/ceph/src/msg/async/rdma/Infiniband.cc: 1255 in Infiniband::QueuePair::~QueuePair()()


________________________________________________________________________________________________________
*** CID 1509762:  Error handling issues  (UNCAUGHT_EXCEPT)
/home/kkeithle/src/github/ceph/src/msg/async/rdma/Infiniband.cc: 1255 in Infiniband::QueuePair::~QueuePair()()
1249         delete cq;
1250         return NULL;
1251       }
1252       return cq;
1253     }
1254     
>>>     CID 1509762:  Error handling issues  (UNCAUGHT_EXCEPT)
>>>     An exception of type "std::system_error" is thrown but the exception specification "noexcept" doesn't allow it to be thrown. This will result in a call to terminate().
1255     Infiniband::QueuePair::~QueuePair()
1256     {
1257       ldout(cct, 20) << __func__ << " destroy Queue Pair, qp number: " << qp->qp_num << " left SQ WR " << recv_queue.size() << dendl;
1258       if (qp) {
1259         ldout(cct, 20) << __func__ << " destroy qp=" << qp << dendl;
1260         ceph_assert(!ibv_destroy_qp(qp));

** CID 1509761:  Error handling issues  (CHECKED_RETURN)
/src/pybind/rados/rados.c: 56264 in __pyx_pw_5rados_5Ioctx_87watch()


________________________________________________________________________________________________________
*** CID 1509761:  Error handling issues  (CHECKED_RETURN)
/src/pybind/rados/rados.c: 56264 in __pyx_pw_5rados_5Ioctx_87watch()
56258       __Pyx_RaiseArgtupleInvalid("watch", 0, 2, 4, PyTuple_GET_SIZE(__pyx_args)); __PYX_ERR(0, 3314, __pyx_L3_error)
56259       __pyx_L3_error:;
56260       __Pyx_AddTraceback("rados.Ioctx.watch", __pyx_clineno, __pyx_lineno, __pyx_filename);
56261       __Pyx_RefNannyFinishContext();
56262       return NULL;
56263       __pyx_L4_argument_unpacking_done:;
>>>     CID 1509761:  Error handling issues  (CHECKED_RETURN)
>>>     Calling "__Pyx__ArgTypeTest" without checking return value (as is done elsewhere 132 out of 132 times).
56264       if (unlikely(!__Pyx_ArgTypeTest(((PyObject *)__pyx_v_obj), (&PyUnicode_Type), 1, "obj", 1))) __PYX_ERR(0, 3314, __pyx_L1_error)
56265       __pyx_r = __pyx_pf_5rados_5Ioctx_86watch(((struct __pyx_obj_5rados_Ioctx *)__pyx_v_self), __pyx_v_obj, __pyx_v_callback, __pyx_v_error_callback, __pyx_v_timeout);
56266     
56267       /* "rados.pyx":3314
56268      *         return completion
56269      * 

** CID 1509760:  Error handling issues  (CHECKED_RETURN)
/src/pybind/rados/rados.c: 47064 in __pyx_pw_5rados_5Ioctx_37aio_remove()


________________________________________________________________________________________________________
*** CID 1509760:  Error handling issues  (CHECKED_RETURN)
/src/pybind/rados/rados.c: 47064 in __pyx_pw_5rados_5Ioctx_37aio_remove()
47058       __Pyx_RaiseArgtupleInvalid("aio_remove", 0, 1, 3, PyTuple_GET_SIZE(__pyx_args)); __PYX_ERR(0, 2640, __pyx_L3_error)
47059       __pyx_L3_error:;
47060       __Pyx_AddTraceback("rados.Ioctx.aio_remove", __pyx_clineno, __pyx_lineno, __pyx_filename);
47061       __Pyx_RefNannyFinishContext();
47062       return NULL;
47063       __pyx_L4_argument_unpacking_done:;
>>>     CID 1509760:  Error handling issues  (CHECKED_RETURN)
>>>     Calling "__Pyx__ArgTypeTest" without checking return value (as is done elsewhere 132 out of 132 times).
47064       if (unlikely(!__Pyx_ArgTypeTest(((PyObject *)__pyx_v_object_name), (&PyUnicode_Type), 1, "object_name", 1))) __PYX_ERR(0, 2640, __pyx_L1_error)
47065       __pyx_r = __pyx_pf_5rados_5Ioctx_36aio_remove(((struct __pyx_obj_5rados_Ioctx *)__pyx_v_self), __pyx_v_object_name, __pyx_v_oncomplete, __pyx_v_onsafe);
47066     
47067       /* "rados.pyx":2640
47068      *         return completion
47069      * 

** CID 1509759:  Program hangs  (SLEEP)
/home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 703 in SimpleRADOSStriper::lock(unsigned long)()


________________________________________________________________________________________________________
*** CID 1509759:  Program hangs  (SLEEP)
/home/kkeithle/src/github/ceph/src/SimpleRADOSStriper.cc: 703 in SimpleRADOSStriper::lock(unsigned long)()
697         } else if (rc == -EBUSY) {
698           if ((slept % 500000) == 0) {
699             d(-1) << "waiting for locks: ";
700             print_lockers(*_dout);
701             *_dout << dendl;
702           }
>>>     CID 1509759:  Program hangs  (SLEEP)
>>>     Call to "usleep" might sleep while holding lock "lock._M_device".
703           usleep(5000);
704           slept += 5000;
705           continue;
706         } else if (rc == -ECANCELED) {
707           /* CMPXATTR failed, a locker didn't cleanup. Try to recover! */
708           if (rc = recover_lock(); rc < 0) {

** CID 1509758:  Error handling issues  (CHECKED_RETURN)
/src/pybind/rbd/rbd.c: 81568 in __pyx_pw_3rbd_17GroupSnapIterator_1__init__()


________________________________________________________________________________________________________
*** CID 1509758:  Error handling issues  (CHECKED_RETURN)
/src/pybind/rbd/rbd.c: 81568 in __pyx_pw_3rbd_17GroupSnapIterator_1__init__()
81562       __Pyx_RaiseArgtupleInvalid("__init__", 1, 1, 1, PyTuple_GET_SIZE(__pyx_args)); __PYX_ERR(0, 5773, __pyx_L3_error)
81563       __pyx_L3_error:;
81564       __Pyx_AddTraceback("rbd.GroupSnapIterator.__init__", __pyx_clineno, __pyx_lineno, __pyx_filename);
81565       __Pyx_RefNannyFinishContext();
81566       return -1;
81567       __pyx_L4_argument_unpacking_done:;
>>>     CID 1509758:  Error handling issues  (CHECKED_RETURN)
>>>     Calling "__Pyx__ArgTypeTest" without checking return value (as is done elsewhere 8 out of 8 times).
81568       if (unlikely(!__Pyx_ArgTypeTest(((PyObject *)__pyx_v_group), __pyx_ptype_3rbd_Group, 1, "group", 0))) __PYX_ERR(0, 5773, __pyx_L1_error)
81569       __pyx_r = __pyx_pf_3rbd_17GroupSnapIterator___init__(((struct __pyx_obj_3rbd_GroupSnapIterator *)__pyx_v_self), __pyx_v_group);
81570     
81571       /* function exit code */
81572       goto __pyx_L0;
81573       __pyx_L1_error:;

** CID 1509757:  Error handling issues  (CHECKED_RETURN)
/src/pybind/rados/rados.c: 47527 in __pyx_pw_5rados_5Ioctx_41set_locator_key()


________________________________________________________________________________________________________
*** CID 1509757:  Error handling issues  (CHECKED_RETURN)
/src/pybind/rados/rados.c: 47527 in __pyx_pw_5rados_5Ioctx_41set_locator_key()
47521       int __pyx_lineno = 0;
47522       const char *__pyx_filename = NULL;
47523       int __pyx_clineno = 0;
47524       PyObject *__pyx_r = 0;
47525       __Pyx_RefNannyDeclarations
47526       __Pyx_RefNannySetupContext("set_locator_key (wrapper)", 0);
>>>     CID 1509757:  Error handling issues  (CHECKED_RETURN)
>>>     Calling "__Pyx__ArgTypeTest" without checking return value (as is done elsewhere 132 out of 132 times).
47527       if (unlikely(!__Pyx_ArgTypeTest(((PyObject *)__pyx_v_loc_key), (&PyUnicode_Type), 1, "loc_key", 1))) __PYX_ERR(0, 2680, __pyx_L1_error)
47528       __pyx_r = __pyx_pf_5rados_5Ioctx_40set_locator_key(((struct __pyx_obj_5rados_Ioctx *)__pyx_v_self), ((PyObject*)__pyx_v_loc_key));
47529     
47530       /* function exit code */
47531       goto __pyx_L0;
47532       __pyx_L1_error:;

** CID 1509756:    (CHECKED_RETURN)
/src/pybind/rgw/rgw.c: 29532 in __Pyx_PyUnicode_Join()
/src/pybind/cephfs/cephfs.c: 44814 in __Pyx_PyUnicode_Join()
/src/pybind/rbd/rbd.c: 99756 in __Pyx_PyUnicode_Join()
/src/pybind/rados/rados.c: 89361 in __Pyx_PyUnicode_Join()


________________________________________________________________________________________________________
*** CID 1509756:    (CHECKED_RETURN)
/src/pybind/rgw/rgw.c: 29532 in __Pyx_PyUnicode_Join()
29526         char_pos = 0;
29527         for (i=0; i < value_count; i++) {
29528             int ukind;
29529             Py_ssize_t ulength;
29530             void *udata;
29531             PyObject *uval = PyTuple_GET_ITEM(value_tuple, i);
>>>     CID 1509756:    (CHECKED_RETURN)
>>>     Calling "_PyUnicode_Ready" without checking return value (as is done elsewhere 8 out of 8 times).
29532             if (unlikely(__Pyx_PyUnicode_READY(uval)))
29533                 goto bad;
29534             ulength = __Pyx_PyUnicode_GET_LENGTH(uval);
29535             if (unlikely(!ulength))
29536                 continue;
29537             if (unlikely(char_pos + ulength < 0))
/src/pybind/cephfs/cephfs.c: 44814 in __Pyx_PyUnicode_Join()
44808         char_pos = 0;
44809         for (i=0; i < value_count; i++) {
44810             int ukind;
44811             Py_ssize_t ulength;
44812             void *udata;
44813             PyObject *uval = PyTuple_GET_ITEM(value_tuple, i);
>>>     CID 1509756:    (CHECKED_RETURN)
>>>     Calling "_PyUnicode_Ready" without checking return value (as is done elsewhere 8 out of 8 times).
44814             if (unlikely(__Pyx_PyUnicode_READY(uval)))
44815                 goto bad;
44816             ulength = __Pyx_PyUnicode_GET_LENGTH(uval);
44817             if (unlikely(!ulength))
44818                 continue;
44819             if (unlikely(char_pos + ulength < 0))
/src/pybind/rbd/rbd.c: 99756 in __Pyx_PyUnicode_Join()
99750         char_pos = 0;
99751         for (i=0; i < value_count; i++) {
99752             int ukind;
99753             Py_ssize_t ulength;
99754             void *udata;
99755             PyObject *uval = PyTuple_GET_ITEM(value_tuple, i);
>>>     CID 1509756:    (CHECKED_RETURN)
>>>     Calling "_PyUnicode_Ready" without checking return value (as is done elsewhere 8 out of 8 times).
99756             if (unlikely(__Pyx_PyUnicode_READY(uval)))
99757                 goto bad;
99758             ulength = __Pyx_PyUnicode_GET_LENGTH(uval);
99759             if (unlikely(!ulength))
99760                 continue;
99761             if (unlikely(char_pos + ulength < 0))
/src/pybind/rados/rados.c: 89361 in __Pyx_PyUnicode_Join()
89355         char_pos = 0;
89356         for (i=0; i < value_count; i++) {
89357             int ukind;
89358             Py_ssize_t ulength;
89359             void *udata;
89360             PyObject *uval = PyTuple_GET_ITEM(value_tuple, i);
>>>     CID 1509756:    (CHECKED_RETURN)
>>>     Calling "_PyUnicode_Ready" without checking return value (as is done elsewhere 8 out of 8 times).
89361             if (unlikely(__Pyx_PyUnicode_READY(uval)))
89362                 goto bad;
89363             ulength = __Pyx_PyUnicode_GET_LENGTH(uval);
89364             if (unlikely(!ulength))
89365                 continue;
89366             if (unlikely(char_pos + ulength < 0))

** CID 1509755:  Control flow issues  (UNREACHABLE)
/src/pybind/rbd/rbd.c: 72245 in __pyx_pf_3rbd_5Image_210snap_get_trash_namespace()


________________________________________________________________________________________________________
*** CID 1509755:  Control flow issues  (UNREACHABLE)
/src/pybind/rbd/rbd.c: 72245 in __pyx_pf_3rbd_5Image_210snap_get_trash_namespace()
72239      *                 }
72240      *         finally:
72241      *             free(_name)             # <<<<<<<<<<<<<<
72242      * 
72243      *     @requires_not_closed
72244      */
>>>     CID 1509755:  Control flow issues  (UNREACHABLE)
>>>     This code cannot be reached: "{
  __pyx_L4_error:
  ;
  {...".
72245       /*finally:*/ {
72246         __pyx_L4_error:;
72247         /*exception exit:*/{
72248           __Pyx_PyThreadState_declare
72249           __Pyx_PyThreadState_assign
72250           __pyx_t_14 = 0; __pyx_t_15 = 0; __pyx_t_16 = 0; __pyx_t_17 = 0; __pyx_t_18 = 0; __pyx_t_19 = 0;

** CID 1509754:  Uninitialized members  (UNINIT_CTOR)
/home/kkeithle/src/github/ceph/src/messages/MMDSPing.h: 19 in MMDSPing::MMDSPing()()


________________________________________________________________________________________________________
*** CID 1509754:  Uninitialized members  (UNINIT_CTOR)
/home/kkeithle/src/github/ceph/src/messages/MMDSPing.h: 19 in MMDSPing::MMDSPing()()
13       static constexpr int COMPAT_VERSION = 1;
14     public:
15       version_t seq;
16     
17     protected:
18       MMDSPing() : MMDSOp(MSG_MDS_PING, HEAD_VERSION, COMPAT_VERSION) {
>>>     CID 1509754:  Uninitialized members  (UNINIT_CTOR)
>>>     Non-static class member "seq" is not initialized in this constructor nor in any functions that it calls.
19       }
20       MMDSPing(version_t seq)
21         : MMDSOp(MSG_MDS_PING, HEAD_VERSION, COMPAT_VERSION), seq(seq) {
22       }
23       ~MMDSPing() final {}
24     

** CID 1509753:  Error handling issues  (UNCAUGHT_EXCEPT)
/home/kkeithle/src/github/ceph/src/osdc/Objecter.cc: 5005 in Objecter::~Objecter()()


________________________________________________________________________________________________________
*** CID 1509753:  Error handling issues  (UNCAUGHT_EXCEPT)
/home/kkeithle/src/github/ceph/src/osdc/Objecter.cc: 5005 in Objecter::~Objecter()()
4999       Dispatcher(cct), messenger(m), monc(mc), service(service)
5000     {
5001       mon_timeout = cct->_conf.get_val<std::chrono::seconds>("rados_mon_op_timeout");
5002       osd_timeout = cct->_conf.get_val<std::chrono::seconds>("rados_osd_op_timeout");
5003     }
5004     
>>>     CID 1509753:  Error handling issues  (UNCAUGHT_EXCEPT)
>>>     An exception of type "boost::container::length_error" is thrown but the exception specification "noexcept" doesn't allow it to be thrown. This will result in a call to terminate().
5005     Objecter::~Objecter()
5006     {
5007       ceph_assert(homeless_session->get_nref() == 1);
5008       ceph_assert(num_homeless_ops == 0);
5009       homeless_session->put();
5010     

** CID 1509752:  Error handling issues  (CHECKED_RETURN)
/src/pybind/rados/rados.c: 63069 in __pyx_pw_5rados_5Ioctx_139remove_omap_keys()


________________________________________________________________________________________________________
*** CID 1509752:  Error handling issues  (CHECKED_RETURN)
/src/pybind/rados/rados.c: 63069 in __pyx_pw_5rados_5Ioctx_139remove_omap_keys()
63063       __Pyx_RaiseArgtupleInvalid("remove_omap_keys", 1, 2, 2, PyTuple_GET_SIZE(__pyx_args)); __PYX_ERR(0, 3821, __pyx_L3_error)
63064       __pyx_L3_error:;
63065       __Pyx_AddTraceback("rados.Ioctx.remove_omap_keys", __pyx_clineno, __pyx_lineno, __pyx_filename);
63066       __Pyx_RefNannyFinishContext();
63067       return NULL;
63068       __pyx_L4_argument_unpacking_done:;
>>>     CID 1509752:  Error handling issues  (CHECKED_RETURN)
>>>     Calling "__Pyx__ArgTypeTest" without checking return value (as is done elsewhere 19 out of 19 times).
63069       if (unlikely(!__Pyx_ArgTypeTest(((PyObject *)__pyx_v_write_op), __pyx_ptype_5rados_WriteOp, 1, "write_op", 0))) __PYX_ERR(0, 3821, __pyx_L1_error)
63070       __pyx_r = __pyx_pf_5rados_5Ioctx_138remove_omap_keys(((struct __pyx_obj_5rados_Ioctx *)__pyx_v_self), __pyx_v_write_op, __pyx_v_keys);
63071     
63072       /* function exit code */
63073       goto __pyx_L0;
63074       __pyx_L1_error:;

** CID 1509751:  Memory - illegal accesses  (USE_AFTER_FREE)
/home/kkeithle/src/github/ceph/src/msg/async/ProtocolV2.cc: 1399 in ProtocolV2::handle_message()()


________________________________________________________________________________________________________
*** CID 1509751:  Memory - illegal accesses  (USE_AFTER_FREE)
/home/kkeithle/src/github/ceph/src/msg/async/ProtocolV2.cc: 1399 in ProtocolV2::handle_message()()
1393         ldout(cct, 1) << __func__ << " decode message failed " << dendl;
1394         return _fault();
1395       } else {
1396         state = READ_MESSAGE_COMPLETE;
1397       }
1398     
>>>     CID 1509751:  Memory - illegal accesses  (USE_AFTER_FREE)
>>>     Using freed pointer "this->connection".
1399       INTERCEPT(17);
1400     
1401       message->set_byte_throttler(connection->policy.throttler_bytes);
1402       message->set_message_throttler(connection->policy.throttler_messages);
1403     
1404       // store reservation size in message, so we don't get confused

** CID 1509750:  Error handling issues  (UNCAUGHT_EXCEPT)
/home/kkeithle/src/github/ceph/src/common/perf_counters_collection.cc: 55 in ceph::common::PerfCountersDeleter::operator ()(ceph::common::PerfCounters *)()


________________________________________________________________________________________________________
*** CID 1509750:  Error handling issues  (UNCAUGHT_EXCEPT)
/home/kkeithle/src/github/ceph/src/common/perf_counters_collection.cc: 55 in ceph::common::PerfCountersDeleter::operator ()(ceph::common::PerfCounters *)()
49     }
50     void PerfCountersCollection::with_counters(std::function<void(const PerfCountersCollectionImpl::CounterMap &)> fn) const
51     {
52       std::lock_guard lck(m_lock);
53       perf_impl.with_counters(fn);
54     }
>>>     CID 1509750:  Error handling issues  (UNCAUGHT_EXCEPT)
>>>     An exception of type "std::system_error" is thrown but the exception specification "noexcept" doesn't allow it to be thrown. This will result in a call to terminate().
55     void PerfCountersDeleter::operator()(PerfCounters* p) noexcept
56     {
57       if (cct)
58         cct->get_perfcounters_collection()->remove(p);
59       delete p;
60     }
61     


________________________________________________________________________________________________________
To view the defects in Coverity Scan visit, https://u15810271.ct.sendgrid.net/ls/click?upn=HRESupC-2F2Czv4BOaCWWCy7my0P0qcxCbhZ31OYv50yojIR8ODHcGVd1JcCGjvdH5QZ17VgLZQT3XYfB8Bhzp4w-3D-3Dapsi_yvgqM0IBcPiStiVTuWpgYFnMA4H-2BJYqMHWw4jQPoaoo-2BtqsVYKtfl9A0JRaS-2FbbUsKzdvQMj2WBidmXXDYpXO5qx9Y4cnFn0p-2FQkZWWe5JHh8ejaBgEwaUzBM3x-2FyM-2FOpvKqhT-2BCzg-2FNUNemZtHf5voIH7BYbWLrdioyp5fcmOVIoUi-2FywPSoY8zfzN1w6jANMlnLaDKN7b-2BOFQMLI5WK5wsImAoh9oNG6AqvJrylMM-3D

